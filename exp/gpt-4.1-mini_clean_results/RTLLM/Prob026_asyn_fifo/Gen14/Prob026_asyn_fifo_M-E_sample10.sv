`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,   // Write domain clock
    input                   rclk,   // Read domain clock
    input                   wrstn,  // Write domain active low reset
    input                   rrstn,  // Read domain active low reset
    input                   winc,   // Write increment (write enable)
    input                   rinc,   // Read increment (read enable)
    input   [WIDTH-1:0]     wdata,  // Data input
    output                  wfull,  // FIFO full indicator (write side)
    output                  rempty, // FIFO empty indicator (read side)
    output reg [WIDTH-1:0]  rdata   // Data output
);

    // Parameter and localparam definitions
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // One extra bit for full/empty distinction in Gray code

    // -----------------------
    // Functions for Gray code
    // -----------------------
    // Binary to Gray
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to Binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin_tmp;
        begin
            bin_tmp[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
            gray2bin = bin_tmp;
        end
    endfunction

    // ------------------------
    // Write Pointer Controller
    // ------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    wire w_en = winc & ~wfull; // Write enable only when not full

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // ------------------------
    // Read Pointer Controller
    // ------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    wire r_en = rinc & ~rempty; // Read enable only when not empty

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // -----------------------------------
    // Pointer Synchronizers (Gray code)
    // -----------------------------------

    // Synchronize read pointer into write clock domain (2 flop synchronizer)
    reg [PTR_WIDTH-1:0] rptr_gray_w_sync1, rptr_gray_w_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_w_sync1 <= 0;
            rptr_gray_w_sync2 <= 0;
        end else begin
            rptr_gray_w_sync1 <= rptr_gray;
            rptr_gray_w_sync2 <= rptr_gray_w_sync1;
        end
    end
    wire [PTR_WIDTH-1:0] rptr_gray_w = rptr_gray_w_sync2;

    // Synchronize write pointer into read clock domain (2 flop synchronizer)
    reg [PTR_WIDTH-1:0] wptr_gray_r_sync1, wptr_gray_r_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_r_sync1 <= 0;
            wptr_gray_r_sync2 <= 0;
        end else begin
            wptr_gray_r_sync1 <= wptr_gray;
            wptr_gray_r_sync2 <= wptr_gray_r_sync1;
        end
    end
    wire [PTR_WIDTH-1:0] wptr_gray_r = wptr_gray_r_sync2;

    // --------------------
    // Full and Empty Flags
    // --------------------
    // FIFO Full when write pointer is equal to read pointer with top two bits inverted
    // For 4-bit address + 1 bit extra (PTR_WIDTH=5 for DEPTH=16)
    // full = (wptr_gray == {~rptr_gray_w[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_w[PTR_WIDTH-3:0]})
    assign wfull = (wptr_gray == {~rptr_gray_w[PTR_WIDTH-1], ~rptr_gray_w[PTR_WIDTH-2], rptr_gray_w[PTR_WIDTH-3:0]});

    // FIFO Empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_r);

    // ------------------
    // Dual-Port RAM Inst
    // ------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Write enable to RAM gated by w_en
    wire ram_wen = w_en;
    wire ram_ren = r_en;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(ram_wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ram_ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -------------------
    // Read Data Register
    // -------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end


endmodule


// -------------------------------------------------
// Dual-Port RAM Module (Simple behavioral model)
// -------------------------------------------------
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

    // Memory array
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