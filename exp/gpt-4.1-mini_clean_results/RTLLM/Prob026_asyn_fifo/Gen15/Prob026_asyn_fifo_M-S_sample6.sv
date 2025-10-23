`timescale 1ns/1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,
    input                  rrstn,
    input                  winc,
    input                  rinc,
    input  [WIDTH-1:0]     wdata,
    output                 wfull,
    output                 rempty,
    output [WIDTH-1:0]     rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Write pointer binary and Gray
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    // Read pointer binary and Gray
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;

    // Synchronize read pointer Gray code into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk;
    // Synchronize write pointer Gray code into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk;

    // Binary to Gray conversion function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to Binary conversion function
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer logic in write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            if (winc && !wfull) begin
                wptr_bin <= wptr_bin + 1'b1;
                wptr_gray <= bin2gray(wptr_bin + 1'b1);
            end
        end
    end

    // Read pointer logic in read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            if (rinc && !rempty) begin
                rptr_bin <= rptr_bin + 1'b1;
                rptr_gray <= bin2gray(rptr_bin + 1'b1);
            end
        end
    end

    // Two-stage synchronizer of read pointer Gray into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_wclk <= 0;
            rptr_gray_sync2_wclk <= 0;
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Two-stage synchronizer of write pointer Gray into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_rclk <= 0;
            wptr_gray_sync2_rclk <= 0;
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // Convert synchronized pointers to binary for address calculation
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync2_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync2_rclk);

    // Extract RAM addresses from binary pointers (lower bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM write enable and read enable
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Full flag: compare write pointer with read pointer synchronized into wclk domain
    assign wfull = (wptr_gray == {~rptr_gray_sync2_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync2_wclk[PTR_WIDTH-3:0]});

    // Empty flag: compare read pointer with write pointer synchronized into rclk domain
    assign rempty = (rptr_gray == wptr_gray_sync2_rclk);

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
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


// Dual-port RAM module
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