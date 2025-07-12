`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input               wclk,
    input               rclk,
    input               wrstn,    // active low write domain reset
    input               rrstn,    // active low read domain reset
    input               winc,     // write increment (write enable)
    input               rinc,     // read increment (read enable)
    input  [WIDTH-1:0]  wdata,    // data input
    output              wfull,    // full flag
    output              rempty,   // empty flag
    output reg [WIDTH-1:0] rdata   // data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // extra bit for full/empty detection

    // --- Gray code conversion functions ---
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i -1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // --- Write pointer (binary and Gray) ---
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_bin_next;
    reg [PTR_WIDTH-1:0] wptr_gray;

    always @(*) begin
        if (winc && !wfull)
            wptr_bin_next = wptr_bin + 1'b1;
        else
            wptr_bin_next = wptr_bin;
    end

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    always @(posedge wclk) begin
        wptr_gray <= bin2gray(wptr_bin);
    end

    // --- Read pointer (binary and Gray) ---
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_bin_next;
    reg [PTR_WIDTH-1:0] rptr_gray;

    always @(*) begin
        if (rinc && !rempty)
            rptr_bin_next = rptr_bin + 1'b1;
        else
            rptr_bin_next = rptr_bin;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    always @(posedge rclk) begin
        rptr_gray <= bin2gray(rptr_bin);
    end

    // --- Synchronize pointers across clock domains with 2-stage synchronizers ---

    // Synchronize read pointer into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync1, rptr_gray_wclk_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync1 <= 0;
            rptr_gray_wclk_sync2 <= 0;
        end else begin
            rptr_gray_wclk_sync1 <= rptr_gray;
            rptr_gray_wclk_sync2 <= rptr_gray_wclk_sync1;
        end
    end

    // Synchronize write pointer into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync1, wptr_gray_rclk_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync1 <= 0;
            wptr_gray_rclk_sync2 <= 0;
        end else begin
            wptr_gray_rclk_sync1 <= wptr_gray;
            wptr_gray_rclk_sync2 <= wptr_gray_rclk_sync1;
        end
    end

    // --- Convert synchronized Gray pointers back to binary ---
    wire [PTR_WIDTH-1:0] rptr_bin_wclk_sync = gray2bin(rptr_gray_wclk_sync2);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk_sync = gray2bin(wptr_gray_rclk_sync2);

    // --- Full and Empty logic ---
    // Full when next write pointer equals read pointer synchronized to write clock domain
    wire [PTR_WIDTH-1:0] wptr_bin_next_inc = wptr_bin + 1'b1;
    assign wfull = (wptr_bin_next_inc == rptr_bin_wclk_sync);

    // Empty when read pointer equals write pointer synchronized to read clock domain
    assign rempty = (rptr_bin == wptr_bin_rclk_sync);

    // --- RAM addresses ---
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // --- Dual-port RAM instance ---
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


// --- Dual-port RAM behavioral model with independent clocks ---
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
        else
            rdata <= rdata;  // hold last data
    end

endmodule