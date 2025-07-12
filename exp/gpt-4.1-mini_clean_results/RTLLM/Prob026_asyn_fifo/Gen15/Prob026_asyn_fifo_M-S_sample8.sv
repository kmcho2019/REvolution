`timescale 1ns/1ps

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
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // extra bit for full/empty distinction

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;

    // Gray-coded write and read pointers
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronize read pointer into write clock domain (2-stage)
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_w, rptr_gray_sync2_w;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_w <= 0;
            rptr_gray_sync2_w <= 0;
        end else begin
            rptr_gray_sync1_w <= rptr_gray;
            rptr_gray_sync2_w <= rptr_gray_sync1_w;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage)
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_r, wptr_gray_sync2_r;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_r <= 0;
            wptr_gray_sync2_r <= 0;
        end else begin
            wptr_gray_sync1_r <= wptr_gray;
            wptr_gray_sync2_r <= wptr_gray_sync1_r;
        end
    end

    // Convert synchronized Gray pointers back to binary for address and comparison
    wire [PTR_WIDTH-1:0] rptr_bin_sync_w = gray2bin(rptr_gray_sync2_w);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_r = gray2bin(wptr_gray_sync2_r);

    // Write pointer increment (wclk domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer increment (rclk domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // RAM addresses are lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Full: write pointer equals read pointer with inverted top two bits
    assign wfull = (wptr_gray == {~rptr_gray_sync2_w[PTR_WIDTH-1], ~rptr_gray_sync2_w[PTR_WIDTH-2], rptr_gray_sync2_w[PTR_WIDTH-3:0]});

    // Empty: read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync2_r);

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

    // Functions for Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
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

endmodule


// Dual-port RAM submodule
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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
    end

endmodule