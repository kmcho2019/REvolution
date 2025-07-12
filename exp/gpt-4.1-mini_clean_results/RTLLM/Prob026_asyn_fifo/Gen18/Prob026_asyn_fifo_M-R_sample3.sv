`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,  // active low reset, synchronous in write domain
    input                 rrstn,  // active low reset, synchronous in read domain
    input                 winc,   // write enable pulse
    input                 rinc,   // read enable pulse
    input  [WIDTH-1:0]    wdata,  // write data input
    output                wfull,  // write full flag
    output                rempty, // read empty flag
    output reg [WIDTH-1:0] rdata  // read data output
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam ADDR_WIDTH = PTR_WIDTH; // Address bits for RAM access
    localparam PTR_SIZE = PTR_WIDTH + 1; // Pointer width for full/empty logic (extra bit for wrap detection)

    // ----------------------
    // Pointer registers (binary) in write domain
    reg [PTR_SIZE-1:0] wbin_q, wbin_d;
    // Pointer registers (binary) in read domain
    reg [PTR_SIZE-1:0] rbin_q, rbin_d;

    // Gray-coded pointers
    wire [PTR_SIZE-1:0] wptr_gray, rptr_gray;
    reg  [PTR_SIZE-1:0] wptr_gray_q, rptr_gray_q;

    // Synchronized pointers for cross-domain communication (Gray-coded)
    reg [PTR_SIZE-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk; // rptr synced to write clock
    reg [PTR_SIZE-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk; // wptr synced to read clock

    // Binary equivalents of synchronized pointers for comparison
    wire [PTR_SIZE-1:0] rbin_sync_wclk;
    wire [PTR_SIZE-1:0] wbin_sync_rclk;

    // Write and read enables gated by full/empty flags
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Addresses to RAM from lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wbin_q[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin_q[ADDR_WIDTH-1:0];

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    // -------------------------
    // Binary to Gray function (pure function)
    function [PTR_SIZE-1:0] bin2gray;
        input [PTR_SIZE-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_SIZE-1] = bin[PTR_SIZE-1];
            for(i = PTR_SIZE-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Gray to binary function (pure function)
    function [PTR_SIZE-1:0] gray2bin;
        input [PTR_SIZE-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_SIZE-1] = gray[PTR_SIZE-1];
            for (i = PTR_SIZE-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // -------------------------
    // Write pointer logic (write clock domain)
    always @(posedge wclk) begin
        if (~wrstn) begin
            wbin_q <= 0;
            wptr_gray_q <= 0;
        end else begin
            if (w_en)
                wbin_q <= wbin_q + 1'b1;
            wptr_gray_q <= bin2gray(wbin_q);
        end
    end

    // Read pointer logic (read clock domain)
    always @(posedge rclk) begin
        if (~rrstn) begin
            rbin_q <= 0;
            rptr_gray_q <= 0;
        end else begin
            if (r_en)
                rbin_q <= rbin_q + 1'b1;
            rptr_gray_q <= bin2gray(rbin_q);
        end
    end

    // -------------------------
    // Synchronize read pointer (Gray) into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_sync1_wclk <= 0;
            rptr_gray_sync2_wclk <= 0;
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray_q;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Synchronize write pointer (Gray) into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_sync1_rclk <= 0;
            wptr_gray_sync2_rclk <= 0;
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray_q;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // Convert synchronized Gray pointers back to binary
    assign rbin_sync_wclk = gray2bin(rptr_gray_sync2_wclk);
    assign wbin_sync_rclk = gray2bin(wptr_gray_sync2_rclk);

    // -------------------------
    // FIFO full condition (write clock domain)
    // FIFO is full when write pointer is one ahead of read pointer (with bits inversed in top two bits)
    // i.e. wptr == {~rptr[PTR_SIZE-1:PTR_SIZE-2], rptr[PTR_SIZE-3:0]}
    wire full_flag;
    assign full_flag = (
        (wbin_q[PTR_SIZE-1] != rbin_sync_wclk[PTR_SIZE-1]) &&
        (wbin_q[PTR_SIZE-2] != rbin_sync_wclk[PTR_SIZE-2]) &&
        (wbin_q[PTR_SIZE-3:0] == rbin_sync_wclk[PTR_SIZE-3:0])
    );
    assign wfull = full_flag;

    // FIFO empty condition (read clock domain)
    assign rempty = (rbin_q == wbin_sync_rclk);

    // -------------------------
    // Output data register (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

    // -------------------------
    // Dual-Port RAM (simple synchronous RAM)
    // Implemented inside the FIFO to avoid module naming conflicts
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (w_en) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port (read clock domain)
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (r_en) begin
            rdata_reg <= mem[raddr];
        end
    end

    assign ram_rdata = rdata_reg;

endmodule