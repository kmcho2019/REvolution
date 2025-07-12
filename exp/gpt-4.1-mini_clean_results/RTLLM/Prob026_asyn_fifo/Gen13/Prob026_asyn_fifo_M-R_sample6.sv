`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low write domain reset
    input                   rrstn,      // active low read domain reset
    input                   winc,       // write increment (push)
    input                   rinc,       // read increment (pop)
    input  [WIDTH-1:0]      wdata,      // data input to FIFO
    output                  wfull,      // FIFO full flag (write domain)
    output                  rempty,     // FIFO empty flag (read domain)
    output [WIDTH-1:0]      rdata       // data output from FIFO
);

    // Derived parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // --------------------------
    // Functions for Gray encoding and decoding
    // --------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // ------------------------------------
    // Write pointer binary and Gray registers
    // ------------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next;
    assign wptr_bin_next = wptr_bin + ((winc && !wfull) ? 1'b1 : 1'b0);

    wire [PTR_WIDTH-1:0] wptr_gray;
    assign wptr_gray = bin2gray(wptr_bin);

    // Write pointer update (sequential)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    // ------------------------------------
    // Read pointer binary and Gray registers
    // ------------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next;
    assign rptr_bin_next = rptr_bin + ((rinc && !rempty) ? 1'b1 : 1'b0);

    wire [PTR_WIDTH-1:0] rptr_gray;
    assign rptr_gray = bin2gray(rptr_bin);

    // Read pointer update (sequential)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    // ------------------------------------
    // Synchronize pointers across clock domains using dedicated modules
    // ------------------------------------

    gray_sync #(
        .WIDTH(PTR_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .in_gray(rptr_gray),
        .out_gray(rptr_gray_sync_wclk)
    );

    gray_sync #(
        .WIDTH(PTR_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .in_gray(wptr_gray),
        .out_gray(wptr_gray_sync_rclk)
    );

    // Synchronized pointers (Gray code)
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;

    // Convert synchronized Gray pointers to binary for address extraction & comparisons
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    // ---------------------------
    // FIFO Full detection logic (in write clock domain)
    // FIFO is full when write pointer's Gray code equals read pointer's Gray code with inverted MSB and second MSB bits
    // ---------------------------
    wire full_flag = (wptr_gray == {~rptr_gray_sync_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync_wclk[PTR_WIDTH-3:0]});

    // ---------------------------
    // FIFO Empty detection logic (in read clock domain)
    // FIFO is empty when read pointer's Gray code equals write pointer's Gray code
    // ---------------------------
    wire empty_flag = (rptr_gray == wptr_gray_sync_rclk);

    assign wfull = full_flag;
    assign rempty = empty_flag;

    // ---------------------------
    // RAM address extraction from binary pointers (lowest bits)
    // ---------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // ---------------------------
    // RAM write/read enables gated by full/empty flags
    // ---------------------------
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // ---------------------------
    // Instantiate Dual-Port RAM
    // ---------------------------
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Output read data
    assign rdata = ram_rdata;

endmodule

// --------------------------------------------------
// Gray code synchronizer module (2-stage flip-flop)
// Synchronizes a Gray code input signal to destination clock domain
// --------------------------------------------------
module gray_sync #(
    parameter WIDTH = 5
)(
    input                   clk,
    input                   rstn,
    input   [WIDTH-1:0]     in_gray,
    output  reg [WIDTH-1:0] out_gray
);
    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= 0;
            out_gray <= 0;
        end else begin
            sync_ff1 <= in_gray;
            out_gray <= sync_ff1;
        end
    end
endmodule