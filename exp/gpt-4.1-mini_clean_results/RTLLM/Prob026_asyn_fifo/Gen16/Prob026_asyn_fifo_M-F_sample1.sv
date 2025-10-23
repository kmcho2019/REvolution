`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // Active low reset for write domain
    input                   rrstn,   // Active low reset for read domain
    input                   winc,    // Write increment (write enable)
    input                   rinc,    // Read increment (read enable)
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1; // One extra bit for full detection

    // --- Gray code conversion functions ---
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
    begin
        bin2gray = (bin >> 1) ^ bin;
    end
    endfunction

    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin;
    begin
        bin[PTR_EXT-1] = gray[PTR_EXT-1];
        for (i = PTR_EXT-2; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
        gray2bin = bin;
    end
    endfunction

    // --- Write domain pointers ---
    reg  [PTR_EXT-1:0] wptr_bin, wptr_gray;
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + 1;
    wire w_en = winc & ~wfull;

    // --- Read domain pointers ---
    reg  [PTR_EXT-1:0] rptr_bin, rptr_gray;
    wire [PTR_EXT-1:0] rptr_bin_next = rptr_bin + 1;
    wire r_en = rinc & ~rempty;

    // --- Synchronize read pointer into write clock domain ---
    reg [PTR_EXT-1:0] rptr_gray_wclk1, rptr_gray_wclk2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk1 <= 0;
            rptr_gray_wclk2 <= 0;
        end else begin
            rptr_gray_wclk1 <= rptr_gray;
            rptr_gray_wclk2 <= rptr_gray_wclk1;
        end
    end

    // --- Synchronize write pointer into read clock domain ---
    reg [PTR_EXT-1:0] wptr_gray_rclk1, wptr_gray_rclk2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk1 <= 0;
            wptr_gray_rclk2 <= 0;
        end else begin
            wptr_gray_rclk1 <= wptr_gray;
            wptr_gray_rclk2 <= wptr_gray_rclk1;
        end
    end

    // --- Write pointer update ---
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // --- Read pointer update ---
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // --- Convert synchronized Gray pointers to binary ---
    wire [PTR_EXT-1:0] rptr_bin_sync = gray2bin(rptr_gray_wclk2);
    wire [PTR_EXT-1:0] wptr_bin_sync = gray2bin(wptr_gray_rclk2);

    // --- RAM addresses ---
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // --- FIFO full condition ---
    // Full when write pointer equals read pointer with inverted top two bits
    assign wfull = (wptr_gray == {~rptr_gray_wclk2[PTR_EXT-1:PTR_EXT-2], rptr_gray_wclk2[PTR_EXT-3:0]});

    // --- FIFO empty condition ---
    // Empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk2);

    // --- RAM read data wire ---
    wire [WIDTH-1:0] ram_rdata;

    // --- Read data output register ---
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // --- Instantiate uniquely named dual-port RAM submodule ---
    async_fifo_dual_port_RAM #(
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


// Unique name dual-port RAM module for async FIFO to avoid multiple declaration conflicts
module async_fifo_dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                         wclk,
    input                         wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]        wdata,
    input                         rclk,
    input                         renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]        rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: synchronous to write clock
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port: synchronous to read clock
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule