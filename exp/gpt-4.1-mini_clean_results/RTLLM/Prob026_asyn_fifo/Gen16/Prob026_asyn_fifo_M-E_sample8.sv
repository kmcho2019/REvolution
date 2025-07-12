`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,    // Write clock
    input                 rclk,    // Read clock
    input                 wrstn,   // Write domain reset, active low
    input                 rrstn,   // Read domain reset, active low
    input                 winc,    // Write increment (push) request
    input                 rinc,    // Read increment (pop) request
    input  [WIDTH-1:0]    wdata,   // Write data input
    output                wfull,   // FIFO full flag (write domain)
    output                rempty,  // FIFO empty flag (read domain)
    output reg [WIDTH-1:0] rdata   // Read data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;  // Extra bit for full detection logic

    // -----------------------
    // Binary Pointers
    // -----------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    wire winc_en = winc & ~wfull;
    wire rinc_en = rinc & ~rempty;

    // Write binary pointer increment
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc_en)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read binary pointer increment
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc_en)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // -----------------------
    // Gray code conversion (binary to Gray)
    // -----------------------
    wire [PTR_WIDTH-1:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // -----------------------
    // Synchronize pointers to opposite clock domains
    // -----------------------
    wire [PTR_WIDTH-1:0] rptr_gray_sync_w; // read ptr synchronized into write clk domain
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_rptr2w (
        .clk(wclk),
        .rstn(wrstn),
        .gray_in(rptr_gray),
        .gray_out(rptr_gray_sync_w)
    );

    wire [PTR_WIDTH-1:0] wptr_gray_sync_r; // write ptr synchronized into read clk domain
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_wptr2r (
        .clk(rclk),
        .rstn(rrstn),
        .gray_in(wptr_gray),
        .gray_out(wptr_gray_sync_r)
    );

    // -----------------------
    // Empty and Full detection based on Gray code pointers
    // empty: read and write pointers equal
    // full: write pointer equals read pointer with MSB and next MSB inverted
    // -----------------------
    assign rempty = (rptr_gray == wptr_gray_sync_r);

    assign wfull = (wptr_gray == {~rptr_gray_sync_w[PTR_WIDTH-1], ~rptr_gray_sync_w[PTR_WIDTH-2], rptr_gray_sync_w[PTR_WIDTH-3:0]});

    // -----------------------
    // Extract RAM addresses from lower bits of binary pointers
    // -----------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire ram_wen = winc_en;
    wire ram_ren = rinc_en;

    wire [WIDTH-1:0] ram_rdata;

    // -----------------------
    // Instantiate dual port RAM
    // -----------------------
    dual_port_RAM #(
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

    // -----------------------
    // Register output data on read clock domain when read enable is asserted
    // -----------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rinc_en)
            rdata <= ram_rdata;
    end

endmodule


// -------------------------------------------------
// Gray code pointer synchronizer: double flop synchronizer
// input: Gray code from async domain
// output: synchronized Gray code in clock domain of clk
// -------------------------------------------------
module gray_sync #(
    parameter WIDTH = 5
) (
    input               clk,
    input               rstn,
    input  [WIDTH-1:0]  gray_in,
    output reg [WIDTH-1:0] gray_out
);

    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_stage1 <= 0;
            gray_out    <= 0;
        end else begin
            sync_stage1 <= gray_in;
            gray_out    <= sync_stage1;
        end
    end

endmodule


// -------------------------------------------------
// Dual-Port RAM behavioral model
// Separate read and write clocks, write enable, read enable signals
// -------------------------------------------------
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