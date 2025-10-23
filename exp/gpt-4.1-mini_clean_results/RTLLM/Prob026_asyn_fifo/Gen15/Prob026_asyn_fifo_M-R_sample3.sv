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
    input   [WIDTH-1:0]     wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // Binary write pointer register
    reg [PTR_WIDTH-1:0] wptr_bin;
    // Binary read pointer register
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Increment write pointer
    wire winc_en = winc & ~wfull;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc_en)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Increment read pointer
    wire rinc_en = rinc & ~rempty;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc_en)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Gray code conversion - combinational logic
    wire [PTR_WIDTH-1:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // Synchronize pointers across clock domains using two-stage synchronizer modules
    wire [PTR_WIDTH-1:0] rptr_gray_sync_w;
    pointer_sync #(.WIDTH(PTR_WIDTH)) read_ptr_sync (
        .clk(wclk),
        .rst_n(wrstn),
        .async_ptr(rptr_gray),
        .sync_ptr(rptr_gray_sync_w)
    );

    wire [PTR_WIDTH-1:0] wptr_gray_sync_r;
    pointer_sync #(.WIDTH(PTR_WIDTH)) write_ptr_sync (
        .clk(rclk),
        .rst_n(rrstn),
        .async_ptr(wptr_gray),
        .sync_ptr(wptr_gray_sync_r)
    );

    // FIFO full detection
    // Full when write pointer = read pointer with MSB and next MSB inverted
    assign wfull = (wptr_gray == {~rptr_gray_sync_w[PTR_WIDTH-1], ~rptr_gray_sync_w[PTR_WIDTH-2], rptr_gray_sync_w[PTR_WIDTH-3:0]});

    // FIFO empty detection
    assign rempty = (rptr_gray == wptr_gray_sync_r);

    // RAM addresses extracted from binary pointer lower bits
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire ram_wen = winc_en;
    wire ram_ren = rinc_en;

    wire [WIDTH-1:0] ram_rdata;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(ram_wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ram_ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Register read data output on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rinc_en)
            rdata <= ram_rdata;
    end

endmodule


// -------------------------------------------------------
// Two-stage Synchronizer for Gray code pointer synchronization
// -------------------------------------------------------
module pointer_sync #(
    parameter WIDTH = 5
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire [WIDTH-1:0] async_ptr,
    output reg  [WIDTH-1:0] sync_ptr
);

    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_stage1 <= 0;
            sync_ptr    <= 0;
        end else begin
            sync_stage1 <= async_ptr;
            sync_ptr    <= sync_stage1;
        end
    end

endmodule


// -------------------------------------------------
// Dual-Port RAM Module (Behavioral)
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