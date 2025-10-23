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
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    // Calculate pointer width based on DEPTH
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1;  // Extra bit for full/empty detection

    // Binary pointers: extended width for full/empty logic
    reg [PTR_EXT-1:0] wptr_bin = {PTR_EXT{1'b0}};
    reg [PTR_EXT-1:0] rptr_bin = {PTR_EXT{1'b0}};

    // Gray code conversion of binary pointers
    wire [PTR_EXT-1:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    wire [PTR_EXT-1:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // Two-stage synchronizers for crossing clock domains
    wire [PTR_EXT-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT-1:0] wptr_gray_sync_rclk;

    // Write enable and read enable gated by full and empty flags
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Increment write pointer on write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_EXT{1'b0}};
        else if (w_en)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Increment read pointer on read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_EXT{1'b0}};
        else if (r_en)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Synchronize read pointer into write clock domain
    pointer_sync #(.WIDTH(PTR_EXT)) sync_rptr_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer into read clock domain
    pointer_sync #(.WIDTH(PTR_EXT)) sync_wptr_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Next write pointer Gray code for full detection
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_EXT-1:0] wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;

    // Full detection:
    // FIFO is full if next write pointer Gray code equals read pointer Gray code with inverted top two bits
    assign wfull =
        (wptr_gray_next[PTR_EXT-3:0] == rptr_gray_sync_wclk[PTR_EXT-3:0]) &&
        (wptr_gray_next[PTR_EXT-1]   != rptr_gray_sync_wclk[PTR_EXT-1]) &&
        (wptr_gray_next[PTR_EXT-2]   != rptr_gray_sync_wclk[PTR_EXT-2]);

    // Empty detection:
    // FIFO is empty if read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // RAM address: lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // RAM data output wire
    wire [WIDTH-1:0] ram_rdata;

    // Register output data on read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Inferred dual-port RAM with separate read and write clocks
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (w_en)
            mem[waddr] <= wdata;
    end

    // Read port (read clock domain)
    reg [WIDTH-1:0] mem_rdata_q;
    always @(posedge rclk) begin
        if (r_en)
            mem_rdata_q <= mem[raddr];
    end
    assign ram_rdata = mem_rdata_q;

endmodule

// Two-stage synchronizer module for crossing clock domains
module pointer_sync #(parameter WIDTH = 4)(
    input                   clk,
    input                   rst_n,
    input      [WIDTH-1:0]  in,
    output reg [WIDTH-1:0]  out
);

    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_stage1 <= {WIDTH{1'b0}};
            out         <= {WIDTH{1'b0}};
        end else begin
            sync_stage1 <= in;
            out         <= sync_stage1;
        end
    end

endmodule