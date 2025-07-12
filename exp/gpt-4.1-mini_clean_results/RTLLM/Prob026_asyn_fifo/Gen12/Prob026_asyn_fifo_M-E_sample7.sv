`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // active-low reset (write domain)
    input                   rrstn,   // active-low reset (read domain)
    input                   winc,
    input                   rinc,
    input       [WIDTH-1:0] wdata,
    output                  wfull,
    output                  rempty,
    output reg  [WIDTH-1:0] rdata
);
    // Calculate address width from depth
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // -------------------------
    // Functions for binary <-> Gray conversion
    // -------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i -1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // -------------------------
    // Write pointer logic (binary and gray)
    // -------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc & ~wfull);
    reg [PTR_WIDTH-1:0] wptr_gray;

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin  <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // -------------------------
    // Read pointer logic (binary and gray)
    // -------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc & ~rempty);
    reg [PTR_WIDTH-1:0] rptr_gray;

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin  <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // -------------------------
    // Synchronize read pointer into write clock domain (gray code)
    // -------------------------
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_sync1_wclk <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync2_wclk <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // -------------------------
    // Synchronize write pointer into read clock domain (gray code)
    // -------------------------
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_sync1_rclk <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync2_rclk <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // -------------------------
    // Full logic:
    // FIFO is full when the write pointer is one position behind the read pointer,
    // with MSB and next MSB bits inverted between the two gray pointers
    // (means write has wrapped around but read has not caught up)
    // This is directly checked on Gray pointers:
    //
    // full if: wptr_gray == {~rptr_gray[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]}
    // -------------------------
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk = rptr_gray_sync2_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    wire full_check;
    assign full_check = (wptr_gray_next[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_sync_wclk[PTR_WIDTH-1:PTR_WIDTH-2]) &&
                        (wptr_gray_next[PTR_WIDTH-3:0]  ==  rptr_gray_sync_wclk[PTR_WIDTH-3:0]);
    assign wfull = full_check;

    // -------------------------
    // Empty logic:
    // FIFO is empty when synchronized write pointer (in read clock domain)
    // equals the read pointer (both in Gray code)
    // -------------------------
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk = wptr_gray_sync2_rclk;
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // -------------------------
    // RAM address lines are the lower bits of the binary pointers
    // -------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable and read enable qualified with full/empty
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // -------------------------
    // Read data output register
    // -------------------------
    wire [WIDTH-1:0] ram_rdata;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // -------------------------
    // Instantiate dual-port RAM
    // -------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_i (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

endmodule

// ========================================================
// dual_port_RAM module:
// Simple synchronous dual-port RAM with separate clocks
// Write port: clocked by wclk, write enable wenc
// Read port:  clocked by rclk, read enable renc
// RAM depth and width parameterized
// ========================================================
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                          wclk,
    input                          wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]         wdata,
    input                          rclk,
    input                          renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]         rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: synchronous to wclk
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port: synchronous to rclk
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule