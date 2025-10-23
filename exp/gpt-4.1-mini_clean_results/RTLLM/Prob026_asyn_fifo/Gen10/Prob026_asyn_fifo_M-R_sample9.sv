`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1;

    // Binary pointers
    reg [PTR_EXT_WIDTH-1:0] wptr_bin;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin;

    // Gray pointers (generated via assign)
    wire [PTR_EXT_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_EXT_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronized pointers crossing clock domains
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk;

    // Synchronizers: two-stage flip-flops per domain crossing
    synchronizer #(.WIDTH(PTR_EXT_WIDTH)) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    synchronizer #(.WIDTH(PTR_EXT_WIDTH)) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Write enable gated by full
    wire w_en = winc & ~wfull;
    // Read enable gated by empty
    wire r_en = rinc & ~rempty;

    // Write and read addresses for RAM are lower PTR_WIDTH bits from binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // RAM read data output wire
    wire [WIDTH-1:0] ram_rdata;

    // Increment binary pointers conditionally on write/read enable with synchronous reset
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) 
            wptr_bin <= 0;
        else 
            wptr_bin <= w_en ? (wptr_bin + 1'b1) : wptr_bin;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= r_en ? (rptr_bin + 1'b1) : rptr_bin;
    end

    // Full flag logic: next write pointer in Gray and synchronized read pointer comparison
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    assign wfull = ( (wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_EXT_WIDTH-3:0]) &&
                     (wptr_gray_next[PTR_EXT_WIDTH-1]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-1])   &&
                     (wptr_gray_next[PTR_EXT_WIDTH-2]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-2]) );

    // Empty flag: read Gray pointer equals synchronized write Gray pointer
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Register output read data on read clock, only update when read enable is asserted
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Dual-port RAM instantiation (renamed module)
    fifo_dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Function: binary to Gray code conversion
    function [PTR_EXT_WIDTH-1:0] bin2gray;
        input [PTR_EXT_WIDTH-1:0] b;
        integer i;
        begin
            bin2gray[PTR_EXT_WIDTH-1] = b[PTR_EXT_WIDTH-1];
            for (i = PTR_EXT_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = b[i+1] ^ b[i];
        end
    endfunction

    // Function: Gray code to binary conversion (not used here, but can be added if needed)
    function [PTR_EXT_WIDTH-1:0] gray2bin;
        input [PTR_EXT_WIDTH-1:0] g;
        integer j;
        begin
            gray2bin[PTR_EXT_WIDTH-1] = g[PTR_EXT_WIDTH-1];
            for (j = PTR_EXT_WIDTH-2; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ g[j];
        end
    endfunction

endmodule


// Two-stage synchronizer for multi-bit signals crossing clock domains
module synchronizer #(
    parameter WIDTH = 4
)(
    input              clk,
    input              rst_n,
    input  [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);
    reg [WIDTH-1:0] ff1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ff1  <= {WIDTH{1'b0}};
            out  <= {WIDTH{1'b0}};
        end else begin
            ff1  <= in;
            out  <= ff1;
        end
    end
endmodule


// Dual-port RAM module renamed to fifo_dual_port_RAM to avoid collisions
module fifo_dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]      wdata,
    input                       rclk,
    input                       renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);
    // RAM array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: synchronous write
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port: synchronous read
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end
endmodule