`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input              wclk,
    input              rclk,
    input              wrstn,
    input              rrstn,
    input              winc,
    input              rinc,
    input  [WIDTH-1:0] wdata,
    output             wfull,
    output             rempty,
    output [WIDTH-1:0] rdata
);

    // Calculate address width (number of bits to address DEPTH)
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // pointer has one extra bit for full detection

    // Dual-port RAM instantiation
    // Ports:
    // input wclk, wenc, waddr, wdata
    // input rclk, renc, raddr
    // output reg rdata
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    // Binary write pointer
    reg [PTR_WIDTH-1:0] wptr_bin;
    // Binary read pointer
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray code pointers
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronized pointers from opposite clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_0, rptr_gray_wclk_1; // sync read pointer into write clk domain
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_0, wptr_gray_rclk_1; // sync write pointer into read clk domain

    // Synchronized pointers binary conversion
    wire [PTR_WIDTH-1:0] rptr_gray_wclk_sync_bin;
    wire [PTR_WIDTH-1:0] wptr_gray_rclk_sync_bin;

    // Write enable and read enable for RAM
    wire wen;
    wire ren;

    // Write and read addresses for RAM (lower ADDR_WIDTH bits of binary pointers)
    wire [ADDR_WIDTH-1:0] waddr_bin;
    wire [ADDR_WIDTH-1:0] raddr_bin;

    //------------------------------------------------------------------------------//
    // Pointer increments and Gray code conversions
    //------------------------------------------------------------------------------//

    // Write pointer binary increment
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (wen)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer binary increment
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (ren)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Binary to Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Convert binary pointers to Gray code
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_gray <= 0;
        else
            wptr_gray <= bin2gray(wptr_bin);
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_gray <= 0;
        else
            rptr_gray <= bin2gray(rptr_bin);
    end

    //------------------------------------------------------------------------------//
    // Pointer Synchronization (Two-stage synchronizers)
    //------------------------------------------------------------------------------//

    // Sync read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_0 <= 0;
            rptr_gray_wclk_1 <= 0;
        end else begin
            rptr_gray_wclk_0 <= rptr_gray;
            rptr_gray_wclk_1 <= rptr_gray_wclk_0;
        end
    end

    // Sync write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_0 <= 0;
            wptr_gray_rclk_1 <= 0;
        end else begin
            wptr_gray_rclk_0 <= wptr_gray;
            wptr_gray_rclk_1 <= wptr_gray_rclk_0;
        end
    end

    //------------------------------------------------------------------------------//
    // Gray code to binary conversion function
    //------------------------------------------------------------------------------//

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin_tmp;
        begin
            bin_tmp[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1)
                bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
            gray2bin = bin_tmp;
        end
    endfunction

    assign rptr_gray_wclk_sync_bin = gray2bin(rptr_gray_wclk_1);
    assign wptr_gray_rclk_sync_bin = gray2bin(wptr_gray_rclk_1);

    //------------------------------------------------------------------------------//
    // Calculate full and empty flags
    //------------------------------------------------------------------------------//

    // FIFO full condition:
    // When write pointer is one cycle ahead of read pointer with MSB and next MSB inverted
    // wptr_gray == {~rptr_gray[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]}
    wire full_condition;
    assign full_condition = (wptr_gray[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_wclk_1[PTR_WIDTH-1:PTR_WIDTH-2]) &&
                            (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_wclk_1[PTR_WIDTH-3:0]);

    assign wfull = full_condition;

    // FIFO empty condition:
    // When synchronized write pointer equals read pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_1);

    //------------------------------------------------------------------------------//
    // Write enable and read enable generation
    // Write enable only when not full and winc asserted
    // Read enable only when not empty and rinc asserted
    //------------------------------------------------------------------------------//
    assign wen = winc & ~wfull;
    assign ren = rinc & ~rempty;

    //------------------------------------------------------------------------------//
    // Generate RAM addresses by converting Gray code pointers to binary and using lower ADDR_WIDTH bits
    //------------------------------------------------------------------------------//

    assign waddr_bin = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr_bin = rptr_bin[ADDR_WIDTH-1:0];

endmodule


//------------------------------------------------------------------------------//
// Dual Port RAM Module
//------------------------------------------------------------------------------//
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                     wclk,
    input                     wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]        wdata,
    input                     rclk,
    input                     renc,
    input  [$clog2(DEPTH)-1:0] raddr,
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
            rdata <= rdata; // Hold previous value if not reading
    end

endmodule