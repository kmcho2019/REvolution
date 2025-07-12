`timescale 1ns/1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,    // Write clock domain
    input                  rclk,    // Read clock domain
    input                  wrstn,   // Write domain async reset, active low
    input                  rrstn,   // Read domain async reset, active low
    input                  winc,    // Write increment (push) request
    input                  rinc,    // Read increment (pop) request
    input      [WIDTH-1:0] wdata,   // Write data input
    output                 wfull,   // Write full flag
    output                 rempty,  // Read empty flag
    output reg [WIDTH-1:0] rdata    // Read data output
);

    // Parameters for address width and pointer width (binary + 1 bit)
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // -------------------------------------------------------
    // Write domain binary pointer (wptr_bin)
    // Incremented only when winc & ~wfull
    // Synchronous reset with wrstn (active low)
    // -------------------------------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;

    wire wpush = winc & ~wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (wpush)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // -------------------------------------------------------
    // Read domain binary pointer (rptr_bin)
    // Incremented only when rinc & ~rempty
    // Synchronous reset with rrstn (active low)
    // -------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;

    wire rpop = rinc & ~rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rpop)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // -------------------------------------------------------
    // Pointer synchronizers for pointer crossing
    // Instead of directly synchronizing Gray code,
    // synchronize the binary pointers bitwise through 2-stage synchronizers per bit.
    // Then convert synchronized binary pointer to Gray in the local domain.
    // -------------------------------------------------------

    // Write pointer bits synchronized into read clock domain
    wire [PTR_WIDTH-1:0] wptr_bin_sync_r;
    genvar i;
    generate
        for (i = 0; i < PTR_WIDTH; i = i +1) begin : WPTR_BIT_SYNC_TO_RCLK
            two_flop_sync bit_sync (
                .clk(rclk),
                .rstn(rrstn),
                .async_sig(wptr_bin[i]),
                .sync_sig(wptr_bin_sync_r[i])
            );
        end
    endgenerate

    // Read pointer bits synchronized into write clock domain
    wire [PTR_WIDTH-1:0] rptr_bin_sync_w;
    generate
        for (i = 0; i < PTR_WIDTH; i = i +1) begin : RPTR_BIT_SYNC_TO_WCLK
            two_flop_sync bit_sync (
                .clk(wclk),
                .rstn(wrstn),
                .async_sig(rptr_bin[i]),
                .sync_sig(rptr_bin_sync_w[i])
            );
        end
    endgenerate

    // -------------------------------------------------------
    // Convert pointers to Gray code for full and empty logic
    // Gray code = binary ^ (binary >> 1)
    // -------------------------------------------------------
    wire [PTR_WIDTH-1:0] wptr_gray       = wptr_bin       ^ (wptr_bin       >> 1);
    wire [PTR_WIDTH-1:0] rptr_gray       = rptr_bin       ^ (rptr_bin       >> 1);
    wire [PTR_WIDTH-1:0] wptr_gray_sync  = wptr_bin_sync_r ^ (wptr_bin_sync_r >> 1);
    wire [PTR_WIDTH-1:0] rptr_gray_sync  = rptr_bin_sync_w ^ (rptr_bin_sync_w >> 1);

    // -------------------------------------------------------
    // Empty: when read pointer equals synchronized write pointer (on read clk domain)
    // Full: when write pointer equals read pointer with MSB and next MSB inverted (on write clk domain)
    //   wfull = wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1], ~rptr_gray_sync[PTR_WIDTH-2], rptr_gray_sync[PTR_WIDTH-3:0]}
    // -------------------------------------------------------
    assign rempty = (rptr_gray == wptr_gray_sync);

    assign wfull  = (wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1], ~rptr_gray_sync[PTR_WIDTH-2], rptr_gray_sync[PTR_WIDTH-3:0]});

    // -------------------------------------------------------
    // RAM addressing: use lower bits of binary pointers for addresses
    // -------------------------------------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM write enable only when write push is valid
    wire wram_en = wpush;
    // RAM read enable only when read pop is valid
    wire rram_en = rpop;

    wire [WIDTH-1:0] ram_rdata;

    // -------------------------------------------------------
    // Instantiate dual-port RAM submodule (behavioral)
    // -------------------------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wram_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rram_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -------------------------------------------------------
    // Register output data on read clock, when rpop is asserted
    // -------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rpop)
            rdata <= ram_rdata;
    end

endmodule

// ---------------------------------------------------------------------------------------
// Two-flop synchronizer for single-bit signal crossing clock domains
// Async input signal is sampled through two flip-flops to mitigate metastability
// ---------------------------------------------------------------------------------------
module two_flop_sync (
    input  wire clk,
    input  wire rstn,
    input  wire async_sig,
    output reg  sync_sig
);

    reg sync_ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= 1'b0;
            sync_sig <= 1'b0;
        end else begin
            sync_ff1 <= async_sig;
            sync_sig <= sync_ff1;
        end
    end

endmodule


// ---------------------------------------------------------------------------------------
// Dual-Port RAM behavioral model with separate clocks for write and read ports
// Write: wclk, wenc, waddr, wdata
// Read:  rclk, renc, raddr, rdata (registered output)
// ---------------------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wire                    wclk,
    input  wire                    wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]        wdata,
    input  wire                    rclk,
    input  wire                    renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]        rdata
);

    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write process
    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    // Read process
    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule