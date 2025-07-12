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
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // Write pointer binary counter
    reg [PTR_WIDTH-1:0] wptr_bin;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1;
    end

    // Read pointer binary counter
    reg [PTR_WIDTH-1:0] rptr_bin;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1;
    end

    // Binary to Gray code (combinational)
    wire [PTR_WIDTH-1:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // Synchronize read pointer into write clock domain (two stage)
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

    // Synchronize write pointer into read clock domain (two stage)
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

    // Gray to binary conversion (simple function)
    function [PTR_WIDTH-1:0] gray_to_bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray_to_bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
        end
    endfunction

    wire [PTR_WIDTH-1:0] rptr_bin_sync_w = gray_to_bin(rptr_gray_sync2_w);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_r = gray_to_bin(wptr_gray_sync2_r);

    // FIFO full when write pointer = read pointer with top two bits inverted
    wire full_flag = (wptr_gray == {~rptr_gray_sync2_w[PTR_WIDTH-1], ~rptr_gray_sync2_w[PTR_WIDTH-2], rptr_gray_sync2_w[PTR_WIDTH-3:0]});
    assign wfull = full_flag;

    // FIFO empty when read pointer = synchronized write pointer
    wire empty_flag = (rptr_gray == wptr_gray_sync2_r);
    assign rempty = empty_flag;

    // RAM addresses from binary counters (lower bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram_inst (
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


module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,
    input                    wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]   wdata,
    input                    rclk,
    input                    renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]   rdata
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