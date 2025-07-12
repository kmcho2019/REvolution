`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low write reset
    input                   rrstn,      // active low read reset
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // --- Write domain binary pointer ---
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // --- Read domain binary pointer ---
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // --- Gray code conversions (combinational) ---
    assign wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    assign rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // --- Synchronize rptr_gray into write clock domain ---
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_rptr_to_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .async_in(rptr_gray),
        .sync_out(rptr_gray_sync_wclk)
    );

    // --- Synchronize wptr_gray into read clock domain ---
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_wptr_to_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .async_in(wptr_gray),
        .sync_out(wptr_gray_sync_rclk)
    );

    // --- Full and empty logic (combinational) ---
    // Full when write pointer is one ahead with inverted top two bits
    wire full_cond = ( (wptr_gray[PTR_WIDTH-1]     == ~rptr_gray_sync_wclk[PTR_WIDTH-1]) &&
                       (wptr_gray[PTR_WIDTH-2]     == ~rptr_gray_sync_wclk[PTR_WIDTH-2]) &&
                       (wptr_gray[PTR_WIDTH-3:0]  ==  rptr_gray_sync_wclk[PTR_WIDTH-3:0]) );

    // Empty when read pointer equals synchronized write pointer
    wire empty_cond = (rptr_gray == wptr_gray_sync_rclk);

    assign wfull = full_cond;
    assign rempty = empty_cond;

    // --- Addresses for RAM access ---
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // --- Instantiate dual port RAM ---
    wire [WIDTH-1:0] ram_rdata;
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // --- Register read data to stabilize output ---
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (r_en)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

endmodule


// ----------------------------
// dual_port_RAM submodule
// ----------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port - synchronous write
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port - synchronous read with output register
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule


// ----------------------------
// gray_sync: double flop synchronizer for Gray code pointers crossing clock domains
// ----------------------------
module gray_sync #(
    parameter WIDTH = 5
)(
    input                   clk,
    input                   rstn,
    input  [WIDTH-1:0]      async_in,
    output [WIDTH-1:0]      sync_out
);

    reg [WIDTH-1:0] sync_ff1;
    reg [WIDTH-1:0] sync_ff2;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= {WIDTH{1'b0}};
            sync_ff2 <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= async_in;
            sync_ff2 <= sync_ff1;
        end
    end

    assign sync_out = sync_ff2;

endmodule