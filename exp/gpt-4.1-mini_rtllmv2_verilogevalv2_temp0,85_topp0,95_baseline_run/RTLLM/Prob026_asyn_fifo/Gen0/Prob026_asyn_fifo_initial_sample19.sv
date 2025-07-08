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
    input      [WIDTH-1:0] wdata,
    output               wfull,
    output               rempty,
    output     [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // for full detection MSB bit extra

    // --------------------------------------
    // Dual-port RAM module
    // --------------------------------------
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wren),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // --------------------------------------
    // Binary counters for write and read pointers
    // --------------------------------------
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            waddr_bin <= 0;
        else if (winc && !wfull)
            waddr_bin <= waddr_bin + 1'b1;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            raddr_bin <= 0;
        else if (rinc && !rempty)
            raddr_bin <= raddr_bin + 1'b1;
    end

    // --------------------------------------
    // Gray code conversion functions
    // --------------------------------------
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

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

    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(waddr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(raddr_bin);

    // --------------------------------------
    // Synchronize pointers between domains with double flip-flop synchronizers
    // --------------------------------------

    // Synchronize read pointer into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // --------------------------------------
    // Convert synchronized Gray pointers back to binary
    // --------------------------------------
    wire [PTR_WIDTH-1:0] raddr_bin_sync = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] waddr_bin_sync = gray2bin(wptr_gray_rclk_sync);

    // --------------------------------------
    // FIFO full and empty detection
    // Full condition:
    //   wptr_gray == {~rptr_gray[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]}
    // Empty condition:
    //   rptr_gray == wptr_gray
    // --------------------------------------
    assign wfull = (wptr_gray == {~rptr_gray_wclk_sync[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

    // --------------------------------------
    // RAM write enable and read enable
    // Write enable only when winc and not full
    // Read enable only when rinc and not empty
    // --------------------------------------
    wire wren = winc && !wfull;
    wire ren  = rinc && !rempty;

endmodule


// --------------------------------------
// Dual-port RAM submodule
// --------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0] wdata,
    input                 rclk,
    input                 renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port - asynchronous read with registered output
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
    end

endmodule