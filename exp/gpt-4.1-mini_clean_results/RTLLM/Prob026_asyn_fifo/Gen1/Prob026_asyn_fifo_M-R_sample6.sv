`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,
    input                  rrstn,
    input                  winc,
    input                  rinc,
    input  [WIDTH-1:0]     wdata,
    output                 wfull,
    output                 rempty,
    output [WIDTH-1:0]     rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam GRAY_WIDTH = PTR_WIDTH + 1;

    // Binary write pointer
    reg [PTR_WIDTH:0] wptr_bin;
    // Binary read pointer
    reg [PTR_WIDTH:0] rptr_bin;

    // Gray-coded pointers
    wire [PTR_WIDTH:0] wptr_gray;
    wire [PTR_WIDTH:0] rptr_gray;

    // Next write pointer binary
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + (winc & ~wfull);

    // Pointer synchronization signals (Gray-coded)
    wire [PTR_WIDTH:0] rptr_gray_sync;  // read pointer synchronized into wclk domain
    wire [PTR_WIDTH:0] wptr_gray_sync;  // write pointer synchronized into rclk domain

    // Write and read addresses (lower PTR_WIDTH bits of binary pointers)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write and read enable signals for RAM
    wire wwrite_en = winc & (~wfull);
    wire rread_en = rinc & (~rempty);

    // Continuous combinational Gray code conversion for write and read pointers
    assign wptr_gray = {wptr_bin[PTR_WIDTH], wptr_bin[PTR_WIDTH-1:0] ^ wptr_bin[PTR_WIDTH-1:0] >> 1};
    assign rptr_gray = {rptr_bin[PTR_WIDTH], rptr_bin[PTR_WIDTH-1:0] ^ rptr_bin[PTR_WIDTH-1:0] >> 1};

    // Pointer synchronization modules
    gray_sync #(.WIDTH(GRAY_WIDTH)) sync_rptr_to_wclk (
        .clk    (wclk),
        .rstn   (wrstn),
        .async_in(rptr_gray),
        .sync_out(rptr_gray_sync)
    );

    gray_sync #(.WIDTH(GRAY_WIDTH)) sync_wptr_to_rclk (
        .clk    (rclk),
        .rstn   (rrstn),
        .async_in(wptr_gray),
        .sync_out(wptr_gray_sync)
    );

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wptr_bin <= 0;
        else if (wwrite_en)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rptr_bin <= 0;
        else if (rread_en)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Calculate full condition:
    // Full when next write pointer Gray code equals synchronized read pointer Gray code with MSB bits inverted
    // full when wptr_gray_next = {~rptr_gray_sync[PTR_WIDTH], ~rptr_gray_sync[PTR_WIDTH-1], rptr_gray_sync[PTR_WIDTH-2:0]}
    wire [PTR_WIDTH:0] wptr_gray_next;
    assign wptr_gray_next = {wptr_bin_next[PTR_WIDTH], wptr_bin_next[PTR_WIDTH-1:0] ^ (wptr_bin_next[PTR_WIDTH-1:0] >> 1)};

    assign wfull = (wptr_gray_next[PTR_WIDTH:PTR_WIDTH-1] == ~rptr_gray_sync[PTR_WIDTH:PTR_WIDTH-1]) &&
                   (wptr_gray_next[PTR_WIDTH-2:0] == rptr_gray_sync[PTR_WIDTH-2:0]);

    // Calculate empty condition: FIFO empty when read pointer Gray code equals synchronized write pointer Gray code
    assign rempty = (rptr_gray == wptr_gray_sync);

    // Instantiate dual-port RAM for storage
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk  (wclk),
        .wenc  (wwrite_en),
        .waddr (waddr),
        .wdata (wdata),
        .rclk  (rclk),
        .renc  (rread_en),
        .raddr (raddr),
        .rdata (rdata)
    );

endmodule


// Gray code synchronizer module: 2-stage synchronizer for Gray code pointer crossing into another clock domain
module gray_sync #(
    parameter WIDTH = 5
)(
    input                  clk,
    input                  rstn,
    input  [WIDTH-1:0]     async_in,
    output reg [WIDTH-1:0] sync_out
);
    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= 0;
            sync_out <= 0;
        end else begin
            sync_ff1 <= async_in;
            sync_out <= sync_ff1;
        end
    end
endmodule


// Dual-port RAM module definition
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]     wdata,
    input                  rclk,
    input                  renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    // Internal memory array
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