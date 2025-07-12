`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,
    input  wire                 rrstn,
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output reg                  wfull,
    output reg                  rempty,
    output wire [WIDTH-1:0]     rdata
);

    // Functions for Gray code conversions
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Write pointer binary counter
    reg [PTR_WIDTH-1:0] waddr_bin;
    // Read pointer binary counter
    reg [PTR_WIDTH-1:0] raddr_bin;

    // Gray coded pointers in local clock domains
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronized pointers crossing clock domains (two-stage registers)
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    // Write enable and read enable signals (combinational)
    wire wen = winc & ~wfull;
    wire ren = rinc & ~rempty;

    // Next binary pointer values
    wire [PTR_WIDTH-1:0] waddr_bin_next = waddr_bin + (wen ? 1 : 0);
    wire [PTR_WIDTH-1:0] raddr_bin_next = raddr_bin + (ren ? 1 : 0);

    // Update binary and Gray pointers on clock edges
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            waddr_bin <= waddr_bin_next;
            wptr_gray <= bin2gray(waddr_bin_next);
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            raddr_bin <= raddr_bin_next;
            rptr_gray <= bin2gray(raddr_bin_next);
        end
    end

    // Synchronize read pointer into write clock domain (two-flop synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_wclk_meta <= {PTR_WIDTH{1'b0}};
            rptr_gray_wclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain (two-flop synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_rclk_meta <= {PTR_WIDTH{1'b0}};
            wptr_gray_rclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Convert Gray synchronized pointers to binary for RAM addressing
    wire [ADDR_WIDTH-1:0] waddr_ram = gray2bin(wptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = gray2bin(rptr_gray)[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM (assumed available as submodule)
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_dual_port_RAM (
        .wclk  (wclk),
        .wenc  (wen),
        .waddr (waddr_ram),
        .wdata (wdata),
        .rclk  (rclk),
        .renc  (ren),
        .raddr (raddr_ram),
        .rdata (rdata)
    );

    // Full flag combinational calculation
    wire [PTR_WIDTH-1:0] rptr_gray_wclk_sync_inv_msb = {~rptr_gray_wclk_sync[PTR_WIDTH-1], ~rptr_gray_wclk_sync[PTR_WIDTH-2]};
    wire full_condition = (wptr_gray == {rptr_gray_wclk_sync_inv_msb, rptr_gray_wclk_sync[PTR_WIDTH-3:0]});

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= full_condition;
        end
    end

    // Empty flag combinational calculation
    wire empty_condition = (rptr_gray == wptr_gray_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= empty_condition;
        end
    end

endmodule