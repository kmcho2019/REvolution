`timescale 1ns / 1ps
module asyn_fifo #
(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input                    wclk,
    input                    rclk,
    input                    wrstn,
    input                    rrstn,
    input                    winc,
    input                    rinc,
    input      [WIDTH-1:0]   wdata,
    output reg               wfull,
    output reg               rempty,
    output     [WIDTH-1:0]   rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // Gray code pointer width

    //-------------------------------------------------------------------------
    // Dual-port RAM module instantiation
    //-------------------------------------------------------------------------
    wire                    wenc;
    wire                    renc;
    wire [ADDR_WIDTH-1:0]   waddr;
    wire [ADDR_WIDTH-1:0]   raddr;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

    //-------------------------------------------------------------------------
    // Write pointer binary & gray, and increment on wclk domain
    //-------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] wptr_gray_buff1, wptr_gray_buff2; // For synchronizing read ptr into wclk domain

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Binary to Gray code for write pointer
    always @(*) begin
        wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    end

    //-------------------------------------------------------------------------
    // Read pointer binary & gray, and increment on rclk domain
    //-------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray_buff1, rptr_gray_buff2; // For synchronizing write ptr into rclk domain

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Binary to Gray code for read pointer
    always @(*) begin
        rptr_gray = (rptr_bin >> 1) ^ rptr_bin;
    end

    //-------------------------------------------------------------------------
    // Synchronize read pointer into write clock domain (2-stage synchronizer)
    //-------------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_buff1 <= 0;
            rptr_gray_buff2 <= 0;
        end else begin
            rptr_gray_buff1 <= rptr_gray;
            rptr_gray_buff2 <= rptr_gray_buff1;
        end
    end

    //-------------------------------------------------------------------------
    // Synchronize write pointer into read clock domain (2-stage synchronizer)
    //-------------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_buff1 <= 0;
            wptr_gray_buff2 <= 0;
        end else begin
            wptr_gray_buff1 <= wptr_gray;
            wptr_gray_buff2 <= wptr_gray_buff1;
        end
    end

    //-------------------------------------------------------------------------
    // Gray code to binary conversion function
    //-------------------------------------------------------------------------
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    //-------------------------------------------------------------------------
    // Extract synchronized pointers binary for full/empty detection and addresses
    //-------------------------------------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk = rptr_gray_buff2;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk = wptr_gray_buff2;

    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    // Current write and read pointers in binary for addressing RAM (lower ADDR_WIDTH bits)
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable: write when winc and not full
    assign wenc = winc & (~wfull);
    // Read enable: read when rinc and not empty
    assign renc = rinc & (~rempty);

    //-------------------------------------------------------------------------
    // Full and empty flag logic
    // Full when write pointer is one ahead of read pointer with inverted MSBs:
    // full = (wptr_gray == {~rptr_gray_sync_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync_wclk[PTR_WIDTH-3:0]})
    // Empty when pointers equal
    //-------------------------------------------------------------------------
    always @(*) begin
        // Empty
        rempty = (rptr_gray == wptr_gray_sync_rclk);
        // Full
        // Check MSB and 2nd MSB inverted, remaining bits equal
        wfull = (wptr_gray == {~rptr_gray_sync_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync_wclk[PTR_WIDTH-3:0]});
    end

endmodule


// -----------------------------------------------------------------------------
// Dual-port RAM module
// -----------------------------------------------------------------------------
module dual_port_RAM #
(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input                     wclk,
    input                     wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]    wdata,
    input                     rclk,
    input                     renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]    rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // hold last data when no read enable
    end

endmodule