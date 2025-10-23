`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                  wclk,
    input  wire                  wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,

    input  wire                  rclk,
    input  wire                  renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
);
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port - registered output for timing stability
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
        else
            rdata <= rdata; // hold previous data if not reading
    end
endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1  // MSB extra for full detection
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,
    input  wire                 rrstn,
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output wire                 wfull,
    output wire                 rempty,
    output wire [WIDTH-1:0]     rdata
);

    // Binary pointer registers (sequential)
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    // Gray pointer registers (registered outputs of binary pointers)
    reg [PTR_WIDTH-1:0] wptr_gray_reg, rptr_gray_reg;

    // Synchronizers for crossing domains: two stage registers
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk; // read ptr synchronized into write clk domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk; // write ptr synchronized into read clk domain

    // Binary to Gray code conversion (pure combinational)
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Gray to Binary conversion (combinational)
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin_val;
        begin
            bin_val[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i=i-1)
                bin_val[i] = bin_val[i+1] ^ gray[i];
            gray2bin = bin_val;
        end
    endfunction

    // Increment write pointer if write enabled and FIFO not full
    wire write_enable = winc & ~wfull;
    wire read_enable  = rinc & ~rempty;

    // Write pointer update (sequential)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin <= {PTR_WIDTH{1'b0}};
            wptr_gray_reg <= {PTR_WIDTH{1'b0}};
        end else if (write_enable) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray_reg <= bin2gray(wptr_bin + 1);
        end else begin
            wptr_bin <= wptr_bin;
            wptr_gray_reg <= wptr_gray_reg;
        end
    end

    // Read pointer update (sequential)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin <= {PTR_WIDTH{1'b0}};
            rptr_gray_reg <= {PTR_WIDTH{1'b0}};
        end else if (read_enable) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray_reg <= bin2gray(rptr_bin + 1);
        end else begin
            rptr_bin <= rptr_bin;
            rptr_gray_reg <= rptr_gray_reg;
        end
    end

    // Synchronize read pointer into write clock domain (2-flip flop synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_sync1_wclk <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync2_wclk <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray_reg;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Synchronize write pointer into read clock domain (2-flip flop synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_sync1_rclk <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync2_rclk <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray_reg;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // Addresses to dual-port RAM: lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(write_enable),
        .waddr(waddr),
        .wdata(wdata),

        .rclk(rclk),
        .renc(read_enable),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Empty and Full detection logic (combinational)
    // Empty when read pointer == synchronized write pointer (in read clk domain)
    assign rempty = (rptr_gray_reg == wptr_gray_sync2_rclk);

    // Full when:
    // write pointer == {~rptr_gray_sync2_wclk[PTR_WIDTH-1], ~rptr_gray_sync2_wclk[PTR_WIDTH-2], rptr_gray_sync2_wclk[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_gray_inv;
    assign rptr_gray_inv = {~rptr_gray_sync2_wclk[PTR_WIDTH-1], ~rptr_gray_sync2_wclk[PTR_WIDTH-2], rptr_gray_sync2_wclk[PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray_reg == rptr_gray_inv);

endmodule