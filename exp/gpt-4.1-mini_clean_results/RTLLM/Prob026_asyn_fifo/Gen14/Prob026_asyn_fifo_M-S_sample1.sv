`timescale 1ns / 1ps
`default_nettype none

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,    // active low reset
    input  wire                 rrstn,    // active low reset
    input  wire                 winc,     // write enable
    input  wire                 rinc,     // read enable
    input  wire [WIDTH-1:0]     wdata,    // data input
    output wire                 wfull,    // fifo full flag
    output wire                 rempty,   // fifo empty flag
    output wire [WIDTH-1:0]     rdata     // data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;  // extra bit for full detection

    // Gray code conversion functions
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write and read binary pointers
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_bin = 0;

    // Next pointers increment if enable and not full/empty
    wire winc_en = winc && !wfull;
    wire rinc_en = rinc && !rempty;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc_en ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc_en ? 1'b1 : 1'b0);

    // Gray pointers
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronize read pointer into write clock domain (2-stage)
    reg [PTR_WIDTH-1:0] rptr_gray_sync_w1 = 0, rptr_gray_sync_w2 = 0;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_w1 <= 0;
            rptr_gray_sync_w2 <= 0;
        end else begin
            rptr_gray_sync_w1 <= rptr_gray;
            rptr_gray_sync_w2 <= rptr_gray_sync_w1;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage)
    reg [PTR_WIDTH-1:0] wptr_gray_sync_r1 = 0, wptr_gray_sync_r2 = 0;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_r1 <= 0;
            wptr_gray_sync_r2 <= 0;
        end else begin
            wptr_gray_sync_r1 <= wptr_gray;
            wptr_gray_sync_r2 <= wptr_gray_sync_r1;
        end
    end

    // Convert synchronized pointers to binary
    wire [PTR_WIDTH-1:0] rptr_bin_sync = gray2bin(rptr_gray_sync_w2);
    wire [PTR_WIDTH-1:0] wptr_bin_sync = gray2bin(wptr_gray_sync_r2);

    // Full detection:
    // FIFO full if write pointer == read pointer with top two bits inverted and rest equal (Gray code)
    wire full_flag = (wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_sync_w2[PTR_WIDTH-1]) &&
                     (wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_sync_w2[PTR_WIDTH-2]) &&
                     (wptr_gray[PTR_WIDTH-3:0] ==  rptr_gray_sync_w2[PTR_WIDTH-3:0]);

    // Empty detection:
    // FIFO empty if read pointer equals synchronized write pointer
    wire empty_flag = (rptr_gray == wptr_gray_sync_r2);

    assign wfull  = full_flag;
    assign rempty = empty_flag;

    // Update pointers
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    // RAM addressing: lower ADDR_WIDTH bits of pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write and read enable signals for RAM
    wire wen = winc_en;
    wire ren = rinc_en;

    // Instantiate dual-port RAM
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

`default_nettype wire