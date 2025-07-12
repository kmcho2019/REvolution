`timescale 1ns/1ps

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
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // extra bit for distinguishing full/empty

    // Write pointer binary counter
    reg [PTR_WIDTH-1:0] wptr_bin;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer binary counter
    reg [PTR_WIDTH-1:0] rptr_bin;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Gray code conversion as combinational functions
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronize read pointer into write clock domain
    wire [PTR_WIDTH-1:0] rptr_gray_sync_w;
    gray_sync #(.WIDTH(PTR_WIDTH)) read_ptr_sync (
        .clk(wclk),
        .rst_n(wrstn),
        .in_sig(rptr_gray),
        .out_sig(rptr_gray_sync_w)
    );

    // Synchronize write pointer into read clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_sync_r;
    gray_sync #(.WIDTH(PTR_WIDTH)) write_ptr_sync (
        .clk(rclk),
        .rst_n(rrstn),
        .in_sig(wptr_gray),
        .out_sig(wptr_gray_sync_r)
    );

    // Convert synchronized Gray code pointers back to binary for comparison and addressing
    wire [PTR_WIDTH-1:0] rptr_bin_sync_w = gray2bin(rptr_gray_sync_w);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_r = gray2bin(wptr_gray_sync_r);

    // Determine FIFO full condition
    // Full when write pointer is equal to read pointer with top two bits inverted
    wire full_condition = (wptr_gray == {~rptr_gray_sync_w[PTR_WIDTH-1], ~rptr_gray_sync_w[PTR_WIDTH-2], rptr_gray_sync_w[PTR_WIDTH-3:0]});
    assign wfull = full_condition;

    // Determine FIFO empty condition
    // Empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_r);

    // Write and read addresses are lower bits of respective binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Instantiate dual-port RAM module (renamed to dp_ram to avoid name conflicts)
    dp_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


// Two-stage Gray code synchronizer module
module gray_sync #(parameter WIDTH = 5) (
    input wire clk,
    input wire rst_n,
    input wire [WIDTH-1:0] in_sig,
    output reg [WIDTH-1:0] out_sig
);

    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_stage1 <= 0;
            out_sig <= 0;
        end else begin
            sync_stage1 <= in_sig;
            out_sig <= sync_stage1;
        end
    end

endmodule


// Dual-port RAM module with separate clocks and independent read/write
module dp_ram #(
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

    // Write port - synchronous to wclk
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port - synchronous to rclk
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule