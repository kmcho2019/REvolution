`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // active low write reset
    input                   rrstn,   // active low read reset
    input                   winc,    // write enable pulse (1 cycle)
    input                   rinc,    // read enable pulse (1 cycle)
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    // Pointer width (address bits)
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1; // extra bit for full detection wrap-around

    // -------------------------------------------------------
    // Binary to Gray code conversion (PTR_EXT bits)
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Gray code to binary conversion (PTR_EXT bits)
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin;
    begin
        bin[PTR_EXT-1] = gray[PTR_EXT-1];
        for(i = PTR_EXT-2; i >= 0; i = i - 1) begin
            bin[i] = bin[i+1] ^ gray[i];
        end
        gray2bin = bin;
    end
    endfunction

    // -------------------------------------------------------
    // Write domain pointers and logic
    reg [PTR_EXT-1:0] wptr_bin, wptr_bin_next;
    reg [PTR_EXT-1:0] wptr_gray;

    wire wfull_flag;

    wire winc_en = winc && (~wfull_flag);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    assign wptr_bin_next = wptr_bin + (winc_en ? 1'b1 : 1'b0);

    // -------------------------------------------------------
    // Read domain pointers and logic
    reg [PTR_EXT-1:0] rptr_bin, rptr_bin_next;
    reg [PTR_EXT-1:0] rptr_gray;

    wire rempty_flag;

    wire rinc_en = rinc && (~rempty_flag);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    assign rptr_bin_next = rptr_bin + (rinc_en ? 1'b1 : 1'b0);

    // -------------------------------------------------------
    // Synchronize read pointer gray into write clock domain (2-stage synchronizer)
    reg [PTR_EXT-1:0] rptr_gray_wclk_sync_meta, rptr_gray_wclk_sync;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_sync_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_sync_meta;
        end
    end

    // Synchronize write pointer gray into read clock domain (2-stage synchronizer)
    reg [PTR_EXT-1:0] wptr_gray_rclk_sync_meta, wptr_gray_rclk_sync;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_sync_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_sync_meta;
        end
    end

    // -------------------------------------------------------
    // Full flag detection (in write clock domain)
    // Full when wptr_gray == (read pointer gray with top two bits inverted)
    // This means write pointer has wrapped ahead of read pointer by FIFO depth.

    wire [PTR_EXT-1:0] rptr_gray_sync_inv = {~rptr_gray_wclk_sync[PTR_EXT-1:PTR_EXT-2], rptr_gray_wclk_sync[PTR_EXT-3:0]};
    assign wfull_flag = (wptr_gray == rptr_gray_sync_inv);

    // -------------------------------------------------------
    // Empty flag detection (in read clock domain)
    // Empty when read pointer equals synchronized write pointer
    assign rempty_flag = (rptr_gray == wptr_gray_rclk_sync);

    assign wfull = wfull_flag;
    assign rempty = rempty_flag;

    // -------------------------------------------------------
    // RAM addressing (lower PTR_WIDTH bits of binary pointers)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // RAM read enable same as rinc_en
    wire r_en = rinc_en;
    wire w_en = winc_en;

    // RAM read data
    wire [WIDTH-1:0] ram_rdata;

    // Register read data on read clock when reading and not empty
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // -------------------------------------------------------
    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
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


// Dual-port RAM module: independent clocks for write and read
module dual_port_RAM #(
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
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end
endmodule