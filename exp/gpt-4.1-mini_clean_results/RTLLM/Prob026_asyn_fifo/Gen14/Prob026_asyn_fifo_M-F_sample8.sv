`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,
    input                    rclk,
    input                    wrstn,     // active low reset for write domain
    input                    rrstn,     // active low reset for read domain
    input                    winc,      // write increment enable
    input                    rinc,      // read increment enable
    input      [WIDTH-1:0]   wdata,     // write data input
    output                   wfull,     // FIFO full flag
    output                   rempty,    // FIFO empty flag
    output reg [WIDTH-1:0]   rdata      // read data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Explicit wire declarations for RAM interface signals
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;
    wire [WIDTH-1:0] ram_rdata;

    // --------------------
    // Dual-Port RAM instantiation (assumed externally defined)
    // --------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wfull ? 1'b0 : winc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rempty ? 1'b0 : rinc),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // --------------------
    // Write pointer binary counter and Gray pointer generation
    // --------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_gray;

    assign wptr_bin_next = wptr_bin + ({PTR_WIDTH{(winc && !wfull)}});
    assign wptr_gray = (wptr_bin_next >> 1) ^ wptr_bin_next;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    // --------------------
    // Read pointer binary counter and Gray pointer generation
    // --------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_gray;

    assign rptr_bin_next = rptr_bin + ({PTR_WIDTH{(rinc && !rempty)}});
    assign rptr_gray = (rptr_bin_next >> 1) ^ rptr_bin_next;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // --------------------
    // Synchronizers for pointers crossing clock domains
    // --------------------

    // Synchronize read pointer (Gray) into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_wclk <= 0;
            rptr_gray_sync2_wclk <= 0;
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Synchronize write pointer (Gray) into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_rclk <= 0;
            wptr_gray_sync2_rclk <= 0;
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // --------------------
    // Full detection in write clock domain
    // FIFO full when:
    //   wptr_gray[PTR_WIDTH-1:PTR_WIDTH-2] = ~rptr_gray_sync2_wclk[PTR_WIDTH-1:PTR_WIDTH-2]
    //   and wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync2_wclk[PTR_WIDTH-3:0]
    // --------------------
    wire full_msb_match = (wptr_gray[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_sync2_wclk[PTR_WIDTH-1:PTR_WIDTH-2]);
    wire full_lsb_match = (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync2_wclk[PTR_WIDTH-3:0]);
    assign wfull = full_msb_match && full_lsb_match;

    // --------------------
    // Empty detection in read clock domain
    // FIFO empty when read pointer equals synchronized write pointer
    // --------------------
    assign rempty = (rptr_gray == wptr_gray_sync2_rclk);

    // --------------------
    // Register read data on read enable
    // Read enable only when not empty and rinc asserted
    // --------------------
    wire ram_ren = rinc && !rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (ram_ren)
            rdata <= ram_rdata;
    end

endmodule