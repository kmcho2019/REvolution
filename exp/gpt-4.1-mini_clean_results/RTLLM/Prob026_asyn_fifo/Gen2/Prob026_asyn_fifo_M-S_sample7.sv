`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire               wclk,
    input  wire               rclk,
    input  wire               wrstn,
    input  wire               rrstn,
    input  wire               winc,
    input  wire               rinc,
    input  wire [WIDTH-1:0]   wdata,
    output reg                wfull,
    output reg                rempty,
    output wire [WIDTH-1:0]   rdata
);

    // Binary pointers
    reg [PTR_WIDTH-1:0] wbin;
    reg [PTR_WIDTH-1:0] rbin;

    // Gray pointers
    reg [PTR_WIDTH-1:0] wptr;
    reg [PTR_WIDTH-1:0] rptr;

    // Pointer synchronizers (two-stage)
    reg [PTR_WIDTH-1:0] rptr_wclk_1, rptr_wclk_2;
    reg [PTR_WIDTH-1:0] wptr_rclk_1, wptr_rclk_2;

    // Convert binary to Gray code
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Convert Gray code to binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer increment on wclk domain
    wire winc_en = winc & ~wfull;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wbin <= 0;
            wptr <= 0;
        end else if (winc_en) begin
            wbin <= wbin + 1;
            wptr <= bin2gray(wbin + 1);
        end
    end

    // Read pointer increment on rclk domain
    wire rinc_en = rinc & ~rempty;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rbin <= 0;
            rptr <= 0;
        end else if (rinc_en) begin
            rbin <= rbin + 1;
            rptr <= bin2gray(rbin + 1);
        end
    end

    // Synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_wclk_1 <= 0;
            rptr_wclk_2 <= 0;
        end else begin
            rptr_wclk_1 <= rptr;
            rptr_wclk_2 <= rptr_wclk_1;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_rclk_1 <= 0;
            wptr_rclk_2 <= 0;
        end else begin
            wptr_rclk_1 <= wptr;
            wptr_rclk_2 <= wptr_rclk_1;
        end
    end

    // Convert synchronized pointers back to binary
    wire [PTR_WIDTH-1:0] rbin_wclk_sync = gray2bin(rptr_wclk_2);
    wire [PTR_WIDTH-1:0] wbin_rclk_sync = gray2bin(wptr_rclk_2);

    // Full: when next write pointer equals inverted two MSBs of rptr plus lower bits equal
    wire [PTR_WIDTH-1:0] wptr_next = bin2gray(wbin + 1);
    wire full_condition = (wptr_next == {~rptr_wclk_2[PTR_WIDTH-1:PTR_WIDTH-2], rptr_wclk_2[PTR_WIDTH-3:0]});
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) wfull <= 1'b0;
        else       wfull <= full_condition;
    end

    // Empty: when read pointer equals synchronized write pointer
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) rempty <= 1'b1;
        else        rempty <= (rptr == wptr_rclk_2);
    end

    // RAM address for write and read (lower ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // Write enable and read enable signals to RAM
    wire wen = winc_en;
    wire ren = rinc_en;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
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