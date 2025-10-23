`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,   // active low synchronous reset for write clock domain
    input                 rrstn,   // active low synchronous reset for read clock domain
    input                 winc,    // write enable (increment)
    input                 rinc,    // read enable (increment)
    input  [WIDTH-1:0]    wdata,   // write data input
    output                wfull,   // FIFO full flag (write side)
    output                rempty,  // FIFO empty flag (read side)
    output [WIDTH-1:0]    rdata    // read data output
);

    // Calculate address width from DEPTH
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // -----------------------------
    // POINTERS - binary and Gray code
    // -----------------------------

    // Write pointer (binary and Gray)
    reg [ADDR_WIDTH:0] wptr_bin, wptr_bin_next;    // binary pointer (extra bit for full detection)
    reg [ADDR_WIDTH:0] wptr_gray, wptr_gray_next;  // Gray pointer

    // Read pointer (binary and Gray)
    reg [ADDR_WIDTH:0] rptr_bin, rptr_bin_next;
    reg [ADDR_WIDTH:0] rptr_gray, rptr_gray_next;

    // Synchronized pointers crossing clock domains (Gray-coded)
    reg [ADDR_WIDTH:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk;  // read pointer synchronized to write clock domain
    reg [ADDR_WIDTH:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk;  // write pointer synchronized to read clock domain

    // -----------------------------
    // Binary to Gray and Gray to Binary functions
    // -----------------------------

    // Binary to Gray conversion function
    function [ADDR_WIDTH:0] bin_to_gray(input [ADDR_WIDTH:0] bin);
        integer i;
        begin
            bin_to_gray[ADDR_WIDTH] = bin[ADDR_WIDTH];
            for(i=ADDR_WIDTH-1; i>=0; i=i-1) begin
                bin_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Gray to Binary conversion function
    function [ADDR_WIDTH:0] gray_to_bin(input [ADDR_WIDTH:0] gray);
        integer i;
        begin
            gray_to_bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for(i=ADDR_WIDTH-1; i>=0; i=i-1) begin
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // -----------------------------
    // Write Pointer Logic
    // -----------------------------

    // Increment write pointer binary only if winc and FIFO not full
    wire winc_en = winc & (~wfull);

    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Calculate next write pointer values
    always @* begin
        if (winc_en) begin
            wptr_bin_next = wptr_bin + 1'b1;
        end else begin
            wptr_bin_next = wptr_bin;
        end
        wptr_gray_next = bin_to_gray(wptr_bin_next);
    end

    // -----------------------------
    // Read Pointer Logic
    // -----------------------------

    // Increment read pointer binary only if rinc and FIFO not empty
    wire rinc_en = rinc & (~rempty);

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Calculate next read pointer values
    always @* begin
        if (rinc_en) begin
            rptr_bin_next = rptr_bin + 1'b1;
        end else begin
            rptr_bin_next = rptr_bin;
        end
        rptr_gray_next = bin_to_gray(rptr_bin_next);
    end

    // -----------------------------
    // Pointer Synchronizers (2-stage flip-flop synchronizers)
    // -----------------------------

    // Synchronize read pointer into write clock domain
    always @(posedge wclk) begin
        if (~wrstn) begin
            rptr_gray_sync1_wclk <= 0;
            rptr_gray_sync2_wclk <= 0;
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk) begin
        if (~rrstn) begin
            wptr_gray_sync1_rclk <= 0;
            wptr_gray_sync2_rclk <= 0;
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // -----------------------------
    // Full and Empty Logic
    // -----------------------------

    // FIFO is full if next write pointer equals read pointer synchronized to write clock domain,
    // with the two MSB bits inverted and rest bits same.
    wire [ADDR_WIDTH:0] rptr_gray_sync_wclk = rptr_gray_sync2_wclk;

    wire full_cond =
        (wptr_gray_next[ADDR_WIDTH]     != rptr_gray_sync_wclk[ADDR_WIDTH])   &&  // MSB bits inverted
        (wptr_gray_next[ADDR_WIDTH-1]   != rptr_gray_sync_wclk[ADDR_WIDTH-1]) &&
        (wptr_gray_next[ADDR_WIDTH-2:0] == rptr_gray_sync_wclk[ADDR_WIDTH-2:0]);

    assign wfull = full_cond;

    // FIFO is empty if read pointer equals write pointer synchronized to read clock domain
    wire [ADDR_WIDTH:0] wptr_gray_sync_rclk = wptr_gray_sync2_rclk;

    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // -----------------------------
    // RAM Addressing (use lower bits of binary pointer)
    // -----------------------------

    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM write enable when write enabled and not full
    wire wen = winc_en;
    // RAM read enable when read enabled and not empty
    wire ren = rinc_en;

    // -----------------------------
    // Dual-Port RAM instantiation
    // -----------------------------

    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Register RAM read data synchronized with rclk and ren
    reg [WIDTH-1:0] rdata_reg;

    always @(posedge rclk) begin
        if (~rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (ren)
            rdata_reg <= ram_rdata;
    end

    assign rdata = rdata_reg;

endmodule

// --------------------------------------------------------------------
// Dual-Port RAM with separate read and write clocks and enables
// Write and read addresses of width $clog2(DEPTH)
// --------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                     wclk,
    input                     wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]    wdata,
    input                     rclk,
    input                     renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]    rdata
);

    // RAM storage
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule