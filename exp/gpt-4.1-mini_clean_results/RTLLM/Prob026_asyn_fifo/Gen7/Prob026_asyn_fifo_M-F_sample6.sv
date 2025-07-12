`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,    // Write clock
    input                   rclk,    // Read clock
    input                   wrstn,   // Write domain asynchronous active-low reset
    input                   rrstn,   // Read domain asynchronous active-low reset
    input                   winc,    // Write increment signal (write request)
    input                   rinc,    // Read increment signal (read request)
    input      [WIDTH-1:0]  wdata,   // Data input for write
    output                  wfull,   // Write full flag
    output                  rempty,  // Read empty flag
    output reg [WIDTH-1:0]  rdata    // Data output for read
);

    // Calculate pointer widths
    localparam PTR_WIDTH = $clog2(DEPTH);       // Pointer address bits
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1;   // Pointer width with extra bit for full/empty detection

    // Binary write and read pointers
    reg [PTR_EXT_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin = 0;

    // Gray-coded write and read pointers
    reg [PTR_EXT_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_EXT_WIDTH-1:0] rptr_gray = 0;

    // Synchronized pointers across clock domains
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk;

    // Write enable: only write if not full and write increment asserted
    wire w_en = winc & (~wfull);
    // Read enable: only read if not empty and read increment asserted
    wire r_en = rinc & (~rempty);

    // Write and read addresses to RAM (lower PTR_WIDTH bits of pointers)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // RAM data output wire
    wire [WIDTH-1:0] ram_rdata;

    // Binary to Gray code conversion function
    function [PTR_EXT_WIDTH-1:0] bin2gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for (i = PTR_EXT_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray code to binary conversion function
    function [PTR_EXT_WIDTH-1:0] gray2bin;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j = PTR_EXT_WIDTH-2; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

    // Write pointer logic (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer logic (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer Gray code into write clock domain
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer Gray code into read clock domain
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Calculate next write pointer Gray for full condition checking
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // Full condition:
    // FIFO is full when next write pointer Gray code equals read pointer Gray code with inverted MSB and second MSB
    wire full_condition = 
        (wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_EXT_WIDTH-3:0]) &&
        (wptr_gray_next[PTR_EXT_WIDTH-1] != rptr_gray_sync_wclk[PTR_EXT_WIDTH-1]) &&
        (wptr_gray_next[PTR_EXT_WIDTH-2] != rptr_gray_sync_wclk[PTR_EXT_WIDTH-2]);

    assign wfull = full_condition;

    // Empty condition:
    // FIFO is empty when read pointer Gray code equals synchronized write pointer Gray code
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Register read data at read clock when read enable asserted
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_ram_inst (
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


// Two-stage synchronizer module for multi-bit signals (Gray-coded pointers)
module synchronizer #(
    parameter WIDTH = 4
)(
    input              clk,
    input              rst_n,  // Active low asynchronous reset
    input  [WIDTH-1:0] in,
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


// Dual-port RAM with separate read and write clocks and ports
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

    // RAM storage array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: synchronous write
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port: synchronous read
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule