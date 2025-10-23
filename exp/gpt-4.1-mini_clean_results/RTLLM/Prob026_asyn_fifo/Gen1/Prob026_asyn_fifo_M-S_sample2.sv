`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input                   wclk,
    input                   wenc,
    input      [ADDR_WIDTH-1:0] waddr,
    input      [WIDTH-1:0]  wdata,
    input                   rclk,
    input                   renc,
    input      [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
) (
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

    // Binary pointers
    reg [PTR_WIDTH-1:0] wbin, rbin;

    // Gray code pointers
    reg [PTR_WIDTH-1:0] wptr, rptr;

    // Synchronized pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_sync_wclk_0, rptr_sync_wclk_1;
    reg [PTR_WIDTH-1:0] wptr_sync_rclk_0, wptr_sync_rclk_1;

    // Convert binary to Gray code
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Convert Gray to binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wptr <= 0;
        end else if (winc && !wfull) begin
            wbin <= wbin + 1'b1;
            wptr <= bin2gray(wbin + 1'b1);
        end else begin
            wptr <= bin2gray(wbin);
        end
    end

    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rptr <= 0;
        end else if (rinc && !rempty) begin
            rbin <= rbin + 1'b1;
            rptr <= bin2gray(rbin + 1'b1);
        end else begin
            rptr <= bin2gray(rbin);
        end
    end

    // Synchronize read pointer into write clock domain (2-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync_wclk_0 <= 0;
            rptr_sync_wclk_1 <= 0;
        end else begin
            rptr_sync_wclk_0 <= rptr;
            rptr_sync_wclk_1 <= rptr_sync_wclk_0;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync_rclk_0 <= 0;
            wptr_sync_rclk_1 <= 0;
        end else begin
            wptr_sync_rclk_0 <= wptr;
            wptr_sync_rclk_1 <= wptr_sync_rclk_0;
        end
    end

    // Convert synchronized pointers to binary for comparisons and addresses
    wire [PTR_WIDTH-1:0] rbin_sync_wclk = gray2bin(rptr_sync_wclk_1);
    wire [PTR_WIDTH-1:0] wbin_sync_rclk = gray2bin(wptr_sync_rclk_1);

    // RAM addresses: lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // Write enable and read enable signals for RAM
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(rdata)
    );

    // FIFO full condition:
    // When write pointer wraps ahead of read pointer by exactly DEPTH,
    // the MSB and next MSB bits of wptr are the inverse of those of synchronized rptr,
    // and the lower bits are equal.
    wire full = ( (wptr[PTR_WIDTH-1]  != rptr_sync_wclk_1[PTR_WIDTH-1]) &&
                  (wptr[PTR_WIDTH-2]  != rptr_sync_wclk_1[PTR_WIDTH-2]) &&
                  (wptr[PTR_WIDTH-3:0] == rptr_sync_wclk_1[PTR_WIDTH-3:0]) );

    assign wfull = full;

    // FIFO empty condition: read pointer equals synchronized write pointer
    assign rempty = (rptr == wptr_sync_rclk_1);

endmodule