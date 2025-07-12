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

    localparam PTR_WIDTH = $clog2(DEPTH);        // Pointer width (address bits)
    localparam PTR_EXT = PTR_WIDTH + 1;          // Pointer extended width (Gray code)

    // Binary write and read pointers with reset
    reg [PTR_EXT-1:0] wptr_bin = {PTR_EXT{1'b0}};
    reg [PTR_EXT-1:0] rptr_bin = {PTR_EXT{1'b0}};

    // Gray code pointers (combinational)
    wire [PTR_EXT-1:0] wptr_gray;
    wire [PTR_EXT-1:0] rptr_gray;

    // Synchronized pointers (Gray code) crossing clock domains
    wire [PTR_EXT-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT-1:0] wptr_gray_sync_rclk;

    // Write and read enables gated by full and empty
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM addresses from binary pointers lower bits
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // RAM read data
    wire [WIDTH-1:0] ram_rdata;

    // Convert binary to Gray code function
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_EXT-1] = bin[PTR_EXT-1];
            for (i = PTR_EXT-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Convert Gray code to binary function
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer j;
        begin
            gray2bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for (j = PTR_EXT-2; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

    // Write pointer logic with synchronous reset
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_EXT{1'b0}};
        else if (w_en)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer logic with synchronous reset
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_EXT{1'b0}};
        else if (r_en)
            rptr_bin <= rptr_bin + 1'b1;
    end

    assign wptr_gray = bin2gray(wptr_bin);
    assign rptr_gray = bin2gray(rptr_bin);

    // Two-stage synchronizers for pointer crossing clock domains
    pointer_sync #(.WIDTH(PTR_EXT)) sync_rptr_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    pointer_sync #(.WIDTH(PTR_EXT)) sync_wptr_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Calculate next write pointer (binary +1) and its Gray code
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_EXT-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // FIFO FULL condition:
    // When the next write pointer equals the read pointer with inverted MSB and inverted next MSB
    assign wfull = (wptr_gray_next[PTR_EXT-3:0] == rptr_gray_sync_wclk[PTR_EXT-3:0]) &&
                   (wptr_gray_next[PTR_EXT-1]   != rptr_gray_sync_wclk[PTR_EXT-1]) &&
                   (wptr_gray_next[PTR_EXT-2]   != rptr_gray_sync_wclk[PTR_EXT-2]);

    // FIFO EMPTY condition:
    // When the read pointer equals the synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Register read data on read clock with reset
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM with separated clocks, separate addresses, and enables
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


// Two-stage synchronizer for pointer crossing clock domains.
// Explicit two flip-flop stages, all registers defined for area and timing optimization.
module pointer_sync #(parameter WIDTH = 4)(
    input                  clk,
    input                  rst_n,
    input      [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

    reg [WIDTH-1:0] sync_stage1 = {WIDTH{1'b0}};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_stage1 <= {WIDTH{1'b0}};
            out         <= {WIDTH{1'b0}};
        end else begin
            sync_stage1 <= in;
            out         <= sync_stage1;
        end
    end

endmodule


// Dual-port RAM module for asynchronous FIFO storage.
// Separate clocks for write and read, independent enables.
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                          wclk,
    input                          wenc,
    input       [$clog2(DEPTH)-1:0] waddr,
    input       [WIDTH-1:0]        wdata,
    input                          rclk,
    input                          renc,
    input       [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]        rdata
);

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