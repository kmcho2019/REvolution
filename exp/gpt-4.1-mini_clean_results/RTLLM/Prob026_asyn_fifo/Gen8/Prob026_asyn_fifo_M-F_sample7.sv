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

    // Calculate pointer width based on DEPTH, must cover DEPTH addresses
    // PTR_WIDTH covers address bits; PTR_EXT_WIDTH adds 1 MSB bit for full/empty distinction
    localparam PTR_WIDTH = (DEPTH <= 1) ? 1 : $clog2(DEPTH);
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1;

    // Binary pointers in their respective clock domains
    reg [PTR_EXT_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin = 0;

    // Gray code pointers
    wire [PTR_EXT_WIDTH-1:0] wptr_gray;
    wire [PTR_EXT_WIDTH-1:0] rptr_gray;

    // Synchronized Gray pointers crossing clock domains
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk;

    // Write and read enable signals gated by full/empty conditions
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM addresses are lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Binary to Gray code function
    function [PTR_EXT_WIDTH-1:0] binary_to_gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            binary_to_gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for (i = PTR_EXT_WIDTH-2; i >= 0; i = i - 1)
                binary_to_gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to binary function
    function [PTR_EXT_WIDTH-1:0] gray_to_binary;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray_to_binary[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j = PTR_EXT_WIDTH-2; j >= 0; j = j - 1)
                gray_to_binary[j] = gray_to_binary[j+1] ^ gray[j];
        end
    endfunction

    // Write pointer binary increment on write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (w_en)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer binary increment on read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (r_en)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Convert binary pointers to Gray code (combinational)
    assign wptr_gray = binary_to_gray(wptr_bin);
    assign rptr_gray = binary_to_gray(rptr_bin);

    // Two-stage synchronizers for Gray pointers crossing clock domains
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

    // Calculate next write pointer and convert to Gray code for full flag check
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = binary_to_gray(wptr_bin_next);

    // Full condition:
    // When next write pointer matches read pointer with MSB and MSB-1 inverted,
    // FIFO is full (has one slot left)
    assign wfull =
        (wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_EXT_WIDTH-3:0]) &&
        (wptr_gray_next[PTR_EXT_WIDTH-1]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-1])   &&
        (wptr_gray_next[PTR_EXT_WIDTH-2]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-2]);

    // Empty condition: when read and write pointers match in Gray code domain
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Register read data output on read clock when read enabled
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Dual-port RAM instantiation
    dual_port_RAM #(
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


// Two-stage synchronizer for multi-bit signals crossing clock domains
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


// Dual-port RAM module for asynchronous FIFO data storage
module dual_port_RAM #(
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

    // Write operation
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule