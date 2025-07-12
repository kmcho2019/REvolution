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
    input       [WIDTH-1:0] wdata,
    output                  wfull,
    output                  rempty,
    output      [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // One extra bit for full detection

    // Dual-port RAM instantiation
    // waddr and raddr are binary addresses (ADDR_WIDTH bits)
    wire wenc = winc & ~wfull; // Write enable only when not full
    wire renc = rinc & ~rempty; // Read enable only when not empty

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;

    // Gray code pointers (to be transmitted across clock domains)
    reg [PTR_WIDTH-1:0] wptr; // Gray-coded write pointer
    reg [PTR_WIDTH-1:0] rptr; // Gray-coded read pointer

    // Synchronized pointers (received from other domain)
    reg [PTR_WIDTH-1:0] rptr_wclk_sync_0, rptr_wclk_sync_1; // Read pointer synchronized into write clock domain
    reg [PTR_WIDTH-1:0] wptr_rclk_sync_0, wptr_rclk_sync_1; // Write pointer synchronized into read clock domain

    wire [PTR_WIDTH-1:0] rptr_wclk_sync = rptr_wclk_sync_1;
    wire [PTR_WIDTH-1:0] wptr_rclk_sync = wptr_rclk_sync_1;

    // Convert binary address to Gray code
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Convert Gray code to binary address
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Write pointer logic (in write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else begin
            if (wenc) begin
                waddr_bin <= waddr_bin + 1;
                wptr <= bin2gray(waddr_bin + 1);
            end else begin
                wptr <= bin2gray(waddr_bin);
            end
        end
    end

    // Read pointer logic (in read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            if (renc) begin
                raddr_bin <= raddr_bin + 1;
                rptr <= bin2gray(raddr_bin + 1);
            end else begin
                rptr <= bin2gray(raddr_bin);
            end
        end
    end

    // Synchronize read pointer into write clock domain (two-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_wclk_sync_0 <= 0;
            rptr_wclk_sync_1 <= 0;
        end else begin
            rptr_wclk_sync_0 <= rptr;
            rptr_wclk_sync_1 <= rptr_wclk_sync_0;
        end
    end

    // Synchronize write pointer into read clock domain (two-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_rclk_sync_0 <= 0;
            wptr_rclk_sync_1 <= 0;
        end else begin
            wptr_rclk_sync_0 <= wptr;
            wptr_rclk_sync_1 <= wptr_rclk_sync_0;
        end
    end

    // Empty flag generation (read clock domain)
    // rempty is asserted when synchronized write pointer equals read pointer
    assign rempty = (rptr == wptr_rclk_sync);

    // Full flag generation (write clock domain)
    // Full when write pointer is one cycle ahead of read pointer with MSBs inverted
    // Condition: wptr == {~rptr_wclk_sync[PTR_WIDTH-1:PTR_WIDTH-2], rptr_wclk_sync[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_wclk_sync_inverted_upper;
    assign rptr_wclk_sync_inverted_upper = {~rptr_wclk_sync[PTR_WIDTH-1], ~rptr_wclk_sync[PTR_WIDTH-2]};
    assign wfull = (wptr == {rptr_wclk_sync_inverted_upper, rptr_wclk_sync[PTR_WIDTH-3:0]});

    // Convert Gray to binary to get RAM addresses (lower ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Dual-port RAM instantiation
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

endmodule


// Dual-port RAM module
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

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule