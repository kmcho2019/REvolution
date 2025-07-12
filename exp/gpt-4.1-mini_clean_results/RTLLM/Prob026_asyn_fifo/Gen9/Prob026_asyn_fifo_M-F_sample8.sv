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

    // Pointer width calculation: log2(DEPTH)
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1;  // Extra MSB bit for full/empty detection

    // Binary pointers (extended width)
    reg [PTR_EXT_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin = 0;

    // Gray code pointers (binary to Gray encoded)
    wire [PTR_EXT_WIDTH-1:0] wptr_gray;
    wire [PTR_EXT_WIDTH-1:0] rptr_gray;

    // Synchronized pointers crossing clock domains
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk; // read ptr synchronized into wclk domain
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk; // write ptr synchronized into rclk domain

    // Write and read enable gated by full/empty flags
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM addresses: use lower PTR_WIDTH bits from binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // RAM read data output wire
    wire [WIDTH-1:0] ram_rdata;

    // Convert binary to Gray code (function)
    function [PTR_EXT_WIDTH-1:0] binary_to_gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            binary_to_gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for (i = PTR_EXT_WIDTH-2; i >= 0; i = i - 1) begin
                binary_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Convert Gray code to binary (function)
    function [PTR_EXT_WIDTH-1:0] gray_to_binary;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray_to_binary[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j = PTR_EXT_WIDTH-2; j >= 0; j = j - 1) begin
                gray_to_binary[j] = gray_to_binary[j+1] ^ gray[j];
            end
        end
    endfunction

    // Write pointer binary logic - synchronous to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
        end
    end

    // Read pointer binary logic - synchronous to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
        end
    end

    // Combinational Gray code for current write and read pointers
    assign wptr_gray = binary_to_gray(wptr_bin);
    assign rptr_gray = binary_to_gray(rptr_bin);

    // Two-stage synchronizers for pointers crossing clock domains
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Calculate the next write pointer binary and Gray code for full detection
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = binary_to_gray(wptr_bin_next);

    // Full flag: when next write pointer equals read pointer with MSBs inverted
    assign wfull = ( (wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_EXT_WIDTH-3:0]) &&
                     (wptr_gray_next[PTR_EXT_WIDTH-1]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-1])   &&
                     (wptr_gray_next[PTR_EXT_WIDTH-2]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-2]) );

    // Empty flag: when read pointer equals synchronized write pointer (both in Gray code)
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Register output data on read clock when reading enabled
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

    // Dual-port RAM instantiation with unique module name to avoid conflicts
    asyn_fifo_dual_port_ram #(
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

endmodule


// Two-stage synchronizer for multi-bit signal crossing clock domains
module synchronizer #(
    parameter WIDTH = 4
)(
    input               clk,
    input               rst_n,
    input  [WIDTH-1:0]  in,
    output reg [WIDTH-1:0] out
);
    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= {WIDTH{1'b0}};
            out      <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= in;
            out      <= sync_ff1;
        end
    end

endmodule


// Dual-port RAM module for asynchronous FIFO storage with a unique name to avoid conflicts
module asyn_fifo_dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                      rclk,
    input                      renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    // RAM memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule