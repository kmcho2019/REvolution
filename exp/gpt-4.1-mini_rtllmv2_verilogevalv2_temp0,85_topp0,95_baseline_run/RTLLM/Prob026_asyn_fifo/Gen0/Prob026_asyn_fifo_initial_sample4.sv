`timescale 1ns/1ps
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                  wclk,
    input  wire                  rclk,
    input  wire                  wrstn,
    input  wire                  rrstn,
    input  wire                  winc,
    input  wire                  rinc,
    input  wire [WIDTH-1:0]      wdata,
    output wire                  wfull,
    output wire                  rempty,
    output wire [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // one extra bit for full detection

    // -----------------------------------------------------------------------------
    // Dual-port RAM
    // -----------------------------------------------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // -----------------------------------------------------------------------------
    // Write pointer logic (binary and Gray code)
    // -----------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] waddr_bin;
    wire [PTR_WIDTH-1:0] waddr_bin_next;
    reg [PTR_WIDTH-1:0] wptr;       // Gray code write pointer

    assign waddr_bin_next = (winc && !wfull) ? (waddr_bin + 1) : waddr_bin;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            waddr_bin <= 0;
        else
            waddr_bin <= waddr_bin_next;
    end

    // Binary to Gray code conversion
    always @(*) begin
        wptr = (waddr_bin >> 1) ^ waddr_bin;
    end

    // -----------------------------------------------------------------------------
    // Read pointer logic (binary and Gray code)
    // -----------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] raddr_bin;
    wire [PTR_WIDTH-1:0] raddr_bin_next;
    reg [PTR_WIDTH-1:0] rptr;       // Gray code read pointer

    assign raddr_bin_next = (rinc && !rempty) ? (raddr_bin + 1) : raddr_bin;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            raddr_bin <= 0;
        else
            raddr_bin <= raddr_bin_next;
    end

    // Binary to Gray code conversion
    always @(*) begin
        rptr = (raddr_bin >> 1) ^ raddr_bin;
    end

    // -----------------------------------------------------------------------------
    // Read pointer synchronizer into write clock domain (2 stage synchronizer)
    // -----------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_wclk_sync0, rptr_wclk_sync1;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_wclk_sync0 <= 0;
            rptr_wclk_sync1 <= 0;
        end else begin
            rptr_wclk_sync0 <= rptr;
            rptr_wclk_sync1 <= rptr_wclk_sync0;
        end
    end

    // -----------------------------------------------------------------------------
    // Write pointer synchronizer into read clock domain (2 stage synchronizer)
    // -----------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] wptr_rclk_sync0, wptr_rclk_sync1;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_rclk_sync0 <= 0;
            wptr_rclk_sync1 <= 0;
        end else begin
            wptr_rclk_sync0 <= wptr;
            wptr_rclk_sync1 <= wptr_rclk_sync0;
        end
    end

    // -----------------------------------------------------------------------------
    // Full flag generation (write clock domain)
    // FIFO is full if write pointer is one ahead of read pointer with the MSB bits inverted
    // condition: wptr == {~rptr[PTR_WIDTH-1:PTR_WIDTH-2], rptr[PTR_WIDTH-3:0]}
    // -----------------------------------------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_wclk_sync1_inv;
    assign rptr_wclk_sync1_inv = {~rptr_wclk_sync1[PTR_WIDTH-1:PTR_WIDTH-2], rptr_wclk_sync1[PTR_WIDTH-3:0]};
    assign wfull = (wptr == rptr_wclk_sync1_inv);

    // -----------------------------------------------------------------------------
    // Empty flag generation (read clock domain)
    // FIFO is empty if read pointer equals synchronized write pointer
    // -----------------------------------------------------------------------------
    assign rempty = (rptr == wptr_rclk_sync1);

    // -----------------------------------------------------------------------------
    // Write enable and read enable for RAM
    // -----------------------------------------------------------------------------
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // -----------------------------------------------------------------------------
    // Address for write and read ports for RAM (binary pointers lower bits)
    // RAM uses binary pointers truncated to ADDR_WIDTH bits as address
    // -----------------------------------------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_sync_wrapped;
    wire [PTR_WIDTH-1:0] wptr_sync_wrapped;

    // Convert Gray code pointers to binary for addressing RAM
    // Gray to binary conversion function
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer binary address from Gray pointer in write clock domain
    wire [PTR_WIDTH-1:0] wptr_bin_sync;
    assign wptr_bin_sync = gray2bin(wptr);
    // Read pointer binary address from Gray pointer in read clock domain
    wire [PTR_WIDTH-1:0] rptr_bin_sync;
    assign rptr_bin_sync = gray2bin(rptr);

    // Current write address (binary pointer)
    wire [PTR_WIDTH-1:0] waddr_bin;
    // Current read address (binary pointer)
    wire [PTR_WIDTH-1:0] raddr_bin;

    // waddr_bin and raddr_bin are already registers updated at clocks,
    // so no need to overwrite here.

endmodule


// -----------------------------------------------------------------------------
// Dual-port RAM module
// -----------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                  wclk,
    input  wire                  wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,
    input  wire                  rclk,
    input  wire                  renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port - synchronous write on wclk
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read port - synchronous read on rclk
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // hold data if no read enable
    end

endmodule