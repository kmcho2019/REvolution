`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    // Derived parameters
    localparam PTR_WIDTH = $clog2(DEPTH);       // Bits to index DEPTH locations
    localparam GRAY_WIDTH = PTR_WIDTH + 1;      // One extra bit for full/empty detection

    // -----------------------------
    // Binary pointer registers
    // -----------------------------
    reg [PTR_WIDTH:0] wptr_bin;  // Write pointer binary with extra bit
    reg [PTR_WIDTH:0] rptr_bin;  // Read pointer binary with extra bit

    // -----------------------------
    // Gray pointer registers
    // -----------------------------
    reg [GRAY_WIDTH-1:0] wptr_gray;
    reg [GRAY_WIDTH-1:0] rptr_gray;

    // -----------------------------
    // Synchronized pointers (Gray-coded)
    // -----------------------------
    wire [GRAY_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [GRAY_WIDTH-1:0] wptr_gray_sync_rclk;

    // -----------------------------
    // Write and read enable signals gated by full/empty
    // -----------------------------
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // -----------------------------
    // RAM addresses are lower PTR_WIDTH bits of binary pointers
    // -----------------------------
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // -----------------------------
    // RAM output data wire
    // -----------------------------
    wire [WIDTH-1:0] ram_rdata;

    // -----------------------------------
    // Gray code conversion functions
    // -----------------------------------
    function [GRAY_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH:0] bin;
        integer i;
        begin
            bin2gray[GRAY_WIDTH-1] = bin[PTR_WIDTH];
            for(i = PTR_WIDTH-1; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    function [PTR_WIDTH:0] gray2bin;
        input [GRAY_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[PTR_WIDTH] = gray[GRAY_WIDTH-1];
            for(j = PTR_WIDTH-1; j >= 0; j = j - 1) begin
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
            end
        end
    endfunction

    // -----------------------------
    // Write pointer logic (write clock domain)
    // -----------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // -----------------------------
    // Read pointer logic (read clock domain)
    // -----------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // -----------------------------------
    // Synchronizers for pointers crossing clock domains
    // -----------------------------------
    synchronizer #(
        .WIDTH(GRAY_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    synchronizer #(
        .WIDTH(GRAY_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // -----------------------------------
    // Compute next write pointer Gray code (for full detection)
    // -----------------------------------
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [GRAY_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // -----------------------------------
    // Full condition:
    // FIFO is full if next write pointer equals read pointer with two MSBs inverted
    // (FIFO full condition by Gray code pointer logic)
    // -----------------------------------
    wire full_condition;
    assign full_condition =
        (wptr_gray_next[GRAY_WIDTH-3:0] == rptr_gray_sync_wclk[GRAY_WIDTH-3:0]) &&
        (wptr_gray_next[GRAY_WIDTH-1] != rptr_gray_sync_wclk[GRAY_WIDTH-1]) &&
        (wptr_gray_next[GRAY_WIDTH-2] != rptr_gray_sync_wclk[GRAY_WIDTH-2]);

    assign wfull = full_condition;

    // -----------------------------------
    // Empty condition:
    // FIFO is empty if read pointer equals synchronized write pointer (both Gray code)
    // -----------------------------------
    wire empty_condition;
    assign empty_condition = (rptr_gray == wptr_gray_sync_rclk);
    assign rempty = empty_condition;

    // -----------------------------------
    // Register read data on read enable
    // -----------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

    // -----------------------------------
    // Instantiate dual port RAM
    // -----------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_ram_inst (
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


// -----------------------------
// Two-stage synchronizer module for arbitrary bit width signal
// -----------------------------
module synchronizer #(
    parameter WIDTH = 4
)(
    input                  clk,
    input                  rst_n,
    input  [WIDTH-1:0]     in,
    output reg [WIDTH-1:0] out
);
    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sync_ff1 <= {WIDTH{1'b0}};
            out      <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= in;
            out      <= sync_ff1;
        end
    end
endmodule


// ----------------------------------------------------
// Dual-port RAM module with independent clocks & enables
// ----------------------------------------------------
module dual_port_RAM #(
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule