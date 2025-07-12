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

    // Derived parameters
    localparam PTR_WIDTH = $clog2(DEPTH);  // pointer width (address bits)
    localparam ADDR_WIDTH = PTR_WIDTH;      // address width for RAM

    // -------------------------
    // Gray code conversion functions (optimized)
    // -------------------------
    // Binary to Gray code: gray = bin ^ (bin >> 1)
    function [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Gray code to binary conversion for small PTR_WIDTH (unrolled)
    function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        reg [PTR_WIDTH:0] bin;
        begin
            bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for(i = PTR_WIDTH-1; i >= 0; i = i -1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    // -------------------------
    // Pointer registers and synchronization
    // -------------------------

    // Write pointer (binary and gray), includes MSB for full detection (PTR_WIDTH+1 bits)
    reg [PTR_WIDTH:0] wptr_bin;
    reg [PTR_WIDTH:0] wptr_gray;

    // Read pointer (binary and gray)
    reg [PTR_WIDTH:0] rptr_bin;
    reg [PTR_WIDTH:0] rptr_gray;

    // Synchronizers: two stage synchronizer of read pointer into wclk domain
    reg [PTR_WIDTH:0] rptr_gray_sync_wclk_0;
    reg [PTR_WIDTH:0] rptr_gray_sync_wclk_1;

    // Synchronizers: two stage synchronizer of write pointer into rclk domain
    reg [PTR_WIDTH:0] wptr_gray_sync_rclk_0;
    reg [PTR_WIDTH:0] wptr_gray_sync_rclk_1;

    // -------------------------
    // Write Pointer logic (wclk domain)
    // -------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= { (PTR_WIDTH+1){1'b0} };
            wptr_gray <= { (PTR_WIDTH+1){1'b0} };
        end else if (winc && !wfull) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // -------------------------
    // Read Pointer logic (rclk domain)
    // -------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= { (PTR_WIDTH+1){1'b0} };
            rptr_gray <= { (PTR_WIDTH+1){1'b0} };
        end else if (rinc && !rempty) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // -------------------------
    // Read pointer synchronizer into wclk domain
    // -------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk_0 <= { (PTR_WIDTH+1){1'b0} };
            rptr_gray_sync_wclk_1 <= { (PTR_WIDTH+1){1'b0} };
        end else begin
            rptr_gray_sync_wclk_0 <= rptr_gray;
            rptr_gray_sync_wclk_1 <= rptr_gray_sync_wclk_0;
        end
    end

    // -------------------------
    // Write pointer synchronizer into rclk domain
    // -------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk_0 <= { (PTR_WIDTH+1){1'b0} };
            wptr_gray_sync_rclk_1 <= { (PTR_WIDTH+1){1'b0} };
        end else begin
            wptr_gray_sync_rclk_0 <= wptr_gray;
            wptr_gray_sync_rclk_1 <= wptr_gray_sync_rclk_0;
        end
    end

    // -------------------------
    // Synchronizer outputs for calculations
    // -------------------------
    wire [PTR_WIDTH:0] rptr_gray_sync_wclk = rptr_gray_sync_wclk_1;
    wire [PTR_WIDTH:0] wptr_gray_sync_rclk = wptr_gray_sync_rclk_1;

    // -------------------------
    // Full detection logic (in wclk domain)
    // FIFO is full if next wptr_gray equals rptr_gray_sync_wclk with MSB and MSB-1 inverted
    // -------------------------
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_WIDTH:0] wptr_gray_next = bin2gray(wptr_bin_next);

    wire full_cond = (
        (wptr_gray_next[PTR_WIDTH-1:0] == rptr_gray_sync_wclk[PTR_WIDTH-1:0]) && 
        (wptr_gray_next[PTR_WIDTH]   != rptr_gray_sync_wclk[PTR_WIDTH]) &&
        (wptr_gray_next[PTR_WIDTH-1] != rptr_gray_sync_wclk[PTR_WIDTH-1])
    );

    assign wfull = full_cond;

    // -------------------------
    // Empty detection logic (in rclk domain)
    // FIFO is empty if read and synchronized write pointer are equal
    // -------------------------
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // -------------------------
    // RAM address assignments (truncation of lower bits of pointers)
    // -------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // -------------------------
    // RAM enable signals
    // -------------------------
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // -------------------------
    // Instantiate dual-port RAM (renamed to avoid conflicts)
    // -------------------------
    asyn_fifo_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


// Dual-port RAM module renamed to asyn_fifo_ram to avoid simulation conflicts
module asyn_fifo_ram #(
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

    // Memory declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule