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
    input   [WIDTH-1:0]     wdata,
    output                  wfull,
    output                  rempty,
    output  [WIDTH-1:0]     rdata
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Write pointer binary and Gray code
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    // Read pointer binary and Gray code
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;

    // Synchronize read pointer to write clock domain (for full detection)
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_w, rptr_gray_sync2_w;
    // Synchronize write pointer to read clock domain (for empty detection)
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_r, wptr_gray_sync2_r;

    // Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Write pointer management
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_gray_sync1_w <= 0;
            rptr_gray_sync2_w <= 0;
        end else begin
            if (winc && !wfull)
                wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin);
            // Synchronize read pointer from read clock domain
            rptr_gray_sync1_w <= rptr_gray;
            rptr_gray_sync2_w <= rptr_gray_sync1_w;
        end
    end

    // Read pointer management
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            wptr_gray_sync1_r <= 0;
            wptr_gray_sync2_r <= 0;
        end else begin
            if (rinc && !rempty)
                rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin);
            // Synchronize write pointer from write clock domain
            wptr_gray_sync1_r <= wptr_gray;
            wptr_gray_sync2_r <= wptr_gray_sync1_r;
        end
    end

    // Full when next write pointer equals read pointer with top two bits inverted
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin + 1);
    assign wfull = (wptr_gray_next == {~rptr_gray_sync2_w[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync2_w[PTR_WIDTH-3:0]});

    // Empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync2_r);

    // Extract addresses for RAM
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM write and read enable
    wire wenc = winc && !wfull;
    wire renc = rinc && !rempty;

    // RAM output wire
    wire [WIDTH-1:0] ram_rdata;

    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    assign rdata = ram_rdata;

endmodule


// Dual-port RAM behavioral model
module dual_port_ram #(
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