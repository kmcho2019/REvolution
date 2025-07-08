`timescale 1ns / 1ps
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,
    input                 rrstn,
    input                 winc,
    input                 rinc,
    input      [WIDTH-1:0] wdata,
    output reg            wfull,
    output reg            rempty,
    output     [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // one extra bit for full/empty detection

    // 1) Dual-port RAM instantiation
    // RAM ports:
    // input wclk, input wenc, input [ADDR_WIDTH-1:0] waddr, input [WIDTH-1:0] wdata,
    // input rclk, input renc, input [ADDR_WIDTH-1:0] raddr, output reg [WIDTH-1:0] rdata
    wire wenc = winc & (~wfull);
    wire renc = rinc & (~rempty);

    reg [ADDR_WIDTH-1:0] ram_waddr;
    reg [ADDR_WIDTH-1:0] ram_raddr;
    reg [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(ram_waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(ram_raddr),
        .rdata(ram_rdata)
    );

    assign rdata = ram_rdata;

    // 2) Write pointer logic (binary and gray)
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wptr_bin <= 0;
        else if (wenc)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Binary to Gray for write pointer
    always @(*) begin
        wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    end

    // 3) Read pointer logic (binary and gray)
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rptr_bin <= 0;
        else if (renc)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Binary to Gray for read pointer
    always @(*) begin
        rptr_gray = (rptr_bin >> 1) ^ rptr_bin;
    end

    // 4) Synchronize read pointer into write clock domain (for full detection)
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // 5) Synchronize write pointer into read clock domain (for empty detection)
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Convert Gray code to binary function (for pointer comparison)
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    wire [PTR_WIDTH-1:0] rptr_bin_sync = gray2bin(rptr_gray_sync2);
    wire [PTR_WIDTH-1:0] wptr_bin_sync = gray2bin(wptr_gray_sync2);

    // 6) Address pointers for RAM (lower ADDR_WIDTH bits of binary pointers)
    always @(*) begin
        ram_waddr = wptr_bin[ADDR_WIDTH-1:0];
        ram_raddr = rptr_bin[ADDR_WIDTH-1:0];
    end

    // 7) Full flag generation
    // FIFO full when write pointer is one cycle ahead of read pointer with MSBs inverted:
    // Condition: wptr_gray == {~rptr_gray[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_gray_inv_msb = {~rptr_gray_sync2[PTR_WIDTH-1], ~rptr_gray_sync2[PTR_WIDTH-2], rptr_gray_sync2[PTR_WIDTH-3:0]};
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wfull <= 1'b0;
        else
            wfull <= (wptr_gray == rptr_gray_inv_msb);
    end

    // 8) Empty flag generation
    // FIFO empty when read pointer == synchronized write pointer
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rempty <= 1'b1;
        else
            rempty <= (rptr_gray == wptr_gray_sync2);
    end

endmodule

// Dual-port RAM module as submodule
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input       [$clog2(DEPTH)-1:0] waddr,
    input       [WIDTH-1:0] wdata,
    input                   rclk,
    input                   renc,
    input       [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0] rdata
);
    localparam ADDR_WIDTH = $clog2(DEPTH);

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
            rdata <= rdata; // hold previous data if not reading
    end

endmodule