`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                wclk,
    input                rclk,
    input                wrstn,
    input                rrstn,
    input                winc,
    input                rinc,
    input  [WIDTH-1:0]   wdata,
    output               wfull,
    output               rempty,
    output [WIDTH-1:0]   rdata
);

    // Local parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // One more bit for full detection

    // Dual-port RAM instantiation
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wram_wen),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rram_ren),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // -------------------------
    // Write Pointer Domain Logic
    // -------------------------
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_bin_next;
    reg [PTR_WIDTH-1:0] wptr_gray;
    // Write pointer increment logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    // Calculate next binary write pointer
    always @(*) begin
        if (winc && !wfull)
            wptr_bin_next = wptr_bin + 1'b1;
        else
            wptr_bin_next = wptr_bin;
    end

    // Binary to Gray conversion for write pointer
    always @(*) begin
        wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    end

    // -------------------------
    // Read Pointer Domain Logic
    // -------------------------
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_bin_next;
    reg [PTR_WIDTH-1:0] rptr_gray;
    // Read pointer increment logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    // Calculate next binary read pointer
    always @(*) begin
        if (rinc && !rempty)
            rptr_bin_next = rptr_bin + 1'b1;
        else
            rptr_bin_next = rptr_bin;
    end

    // Binary to Gray conversion for read pointer
    always @(*) begin
        rptr_gray = (rptr_bin >> 1) ^ rptr_bin;
    end

    // -------------------------
    // Pointer Synchronization
    // -------------------------

    // Synchronize read pointer into write clock domain (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_wclk <= 0;
            rptr_gray_sync2_wclk <= 0;
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_rclk <= 0;
            wptr_gray_sync2_rclk <= 0;
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // -------------------------
    // Gray to Binary conversion function
    // -------------------------
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Convert synchronized pointers back to binary for comparisons
    wire [PTR_WIDTH-1:0] rptr_sync_bin_wclk = gray2bin(rptr_gray_sync2_wclk);
    wire [PTR_WIDTH-1:0] wptr_sync_bin_rclk = gray2bin(wptr_gray_sync2_rclk);

    // -------------------------
    // Empty and Full detection
    // -------------------------

    // Empty when read pointer equals synchronized write pointer in read domain
    assign rempty = (rptr_gray == wptr_gray_sync2_rclk);

    // Full detection based on Gray code pointer comparison in write domain
    // FIFO is full if the write pointer is one cycle ahead of the read pointer,
    // indicated by the highest two bits inverted and the rest bits equal
    // Formula: wptr == {~rptr[PTR_WIDTH-1:PTR_WIDTH-2], rptr[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_gray_inv;
    assign rptr_gray_inv = {~rptr_gray_sync2_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync2_wclk[PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray == rptr_gray_inv);

    // -------------------------
    // RAM control signals
    // -------------------------
    wire wram_wen = winc & ~wfull;
    wire rram_ren = rinc & ~rempty;

    // RAM addresses from binary pointers lower bits
    wire [ADDR_WIDTH-1:0] waddr_bin = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_bin = rptr_bin[ADDR_WIDTH-1:0];


endmodule


// Dual-port RAM module definition
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]  wdata,
    input                   rclk,
    input                   renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    // Memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port: synchronous write on wclk with wenc enable
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read port: synchronous read on rclk with renc enable
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
    end

endmodule