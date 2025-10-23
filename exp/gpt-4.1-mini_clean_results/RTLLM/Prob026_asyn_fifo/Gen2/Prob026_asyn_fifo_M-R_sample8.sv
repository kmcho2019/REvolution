`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire                  wclk,
    input  wire                  rclk,
    input  wire                  wrstn,
    input  wire                  rrstn,
    input  wire                  winc,
    input  wire                  rinc,
    input  wire [WIDTH-1:0]      wdata,
    output wire                  wfull,
    output wire                  rempty,
    output wire [WIDTH-1:0]      rdata
);

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;

    // Gray code pointers
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronizers
    wire [PTR_WIDTH-1:0] rptr_gray_wclk;  // rptr synchronized into wclk domain
    wire [PTR_WIDTH-1:0] wptr_gray_rclk;  // wptr synchronized into rclk domain

    // Write enable and read enable signals considering full/empty flags
    wire wen = winc & ~wfull;
    wire ren = rinc & ~rempty;

    // Binary to Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Gray code to binary conversion function
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer binary increment and Gray conversion (sequential)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (wen) begin
            waddr_bin <= waddr_bin + 1'b1;
            wptr_gray <= bin2gray(waddr_bin + 1'b1);
        end
    end

    // Read pointer binary increment and Gray conversion (sequential)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (ren) begin
            raddr_bin <= raddr_bin + 1'b1;
            rptr_gray <= bin2gray(raddr_bin + 1'b1);
        end
    end

    // Two-stage synchronizer module for pointers crossing clock domains
    // Synchronizer instance for rptr_gray into wclk domain
    synchronizer #(.WIDTH(PTR_WIDTH)) rptr_sync_inst (
        .clk    (wclk),
        .rstn   (wrstn),
        .d_in   (rptr_gray),
        .d_out  (rptr_gray_wclk)
    );

    // Synchronizer instance for wptr_gray into rclk domain
    synchronizer #(.WIDTH(PTR_WIDTH)) wptr_sync_inst (
        .clk    (rclk),
        .rstn   (rrstn),
        .d_in   (wptr_gray),
        .d_out  (wptr_gray_rclk)
    );

    // Convert Gray to binary pointers for RAM addressing and flag logic
    wire [PTR_WIDTH-1:0] wptr_bin = gray2bin(wptr_gray);
    wire [PTR_WIDTH-1:0] rptr_bin = gray2bin(rptr_gray);

    wire [PTR_WIDTH-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk);

    // RAM addresses (lower bits of pointers)
    wire [ADDR_WIDTH-1:0] waddr_ram = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM (assumed defined externally)
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_ram),
        .rdata(rdata)
    );

    // Full flag (combinational) in write clock domain
    // FIFO full when write pointer equals inverted high bits of read pointer concatenated with low bits equal
    wire [PTR_WIDTH-1:0] rptr_gray_wclk_inv = {~rptr_gray_wclk[PTR_WIDTH-1], ~rptr_gray_wclk[PTR_WIDTH-2], rptr_gray_wclk[PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray == rptr_gray_wclk_inv);

    // Empty flag (combinational) in read clock domain
    assign rempty = (rptr_gray == wptr_gray_rclk);

endmodule


// Synchronizer module for crossing clock domains
module synchronizer #(parameter WIDTH = 4) (
    input  wire             clk,
    input  wire             rstn,
    input  wire [WIDTH-1:0] d_in,
    output reg  [WIDTH-1:0] d_out
);
    reg [WIDTH-1:0] meta;
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            meta <= {WIDTH{1'b0}};
            d_out <= {WIDTH{1'b0}};
        end else begin
            meta <= d_in;
            d_out <= meta;
        end
    end
endmodule