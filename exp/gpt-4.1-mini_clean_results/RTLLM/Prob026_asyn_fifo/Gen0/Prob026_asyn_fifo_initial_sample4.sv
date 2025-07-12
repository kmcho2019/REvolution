`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,
    input                  rrstn,
    input                  winc,
    input                  rinc,
    input  [WIDTH-1:0]     wdata,
    output                 wfull,
    output                 rempty,
    output [WIDTH-1:0]     rdata
);

    // Local parameters
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam GRAY_WIDTH = PTR_WIDTH + 1; // extra bit for full detection

    // Dual-port RAM submodule declaration
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk  (wclk),
        .wenc  (wwrite_en),
        .waddr (waddr),
        .wdata (wdata),
        .rclk  (rclk),
        .renc  (rread_en),
        .raddr (raddr),
        .rdata (rdata)
    );

    // Internal signals

    // Write side binary pointer & Gray pointer
    reg [PTR_WIDTH:0] wptr_bin;   // one extra bit for full detection (wrap bit)
    reg [PTR_WIDTH:0] wptr;

    // Read side binary pointer & Gray pointer
    reg [PTR_WIDTH:0] rptr_bin;
    reg [PTR_WIDTH:0] rptr;

    // Synchronized read pointer in write clock domain (double-flop synchronizer)
    reg [PTR_WIDTH:0] rptr_wclk_ff1, rptr_wclk_ff2;

    // Synchronized write pointer in read clock domain (double-flop synchronizer)
    reg [PTR_WIDTH:0] wptr_rclk_ff1, wptr_rclk_ff2;

    // Write and read address used for RAM (lower PTR_WIDTH bits of binary pointer)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write enable and read enable signals for RAM
    wire wwrite_en;
    wire rread_en;

    // Gray code conversion functions
    function [PTR_WIDTH:0] bin2gray;
        input [PTR_WIDTH:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH] = bin[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    function [PTR_WIDTH:0] gray2bin;
        input [PTR_WIDTH:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i -1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    //--------------------------------------
    // Write pointer binary & gray pointer management (in wclk domain)
    //--------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin <= 0;
            wptr <= 0;
        end else begin
            if (winc & ~wfull) begin
                wptr_bin <= wptr_bin + 1'b1;
                wptr <= bin2gray(wptr_bin + 1'b1);
            end else begin
                wptr <= wptr;
                wptr_bin <= wptr_bin;
            end
        end
    end

    //--------------------------------------
    // Read pointer binary & gray pointer management (in rclk domain)
    //--------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin <= 0;
            rptr <= 0;
        end else begin
            if (rinc & ~rempty) begin
                rptr_bin <= rptr_bin + 1'b1;
                rptr <= bin2gray(rptr_bin + 1'b1);
            end else begin
                rptr <= rptr;
                rptr_bin <= rptr_bin;
            end
        end
    end

    //--------------------------------------
    // Synchronize read pointer into write clock domain (double flip-flop)
    //--------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_wclk_ff1 <= 0;
            rptr_wclk_ff2 <= 0;
        end else begin
            rptr_wclk_ff1 <= rptr;
            rptr_wclk_ff2 <= rptr_wclk_ff1;
        end
    end

    //--------------------------------------
    // Synchronize write pointer into read clock domain (double flip-flop)
    //--------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_rclk_ff1 <= 0;
            wptr_rclk_ff2 <= 0;
        end else begin
            wptr_rclk_ff1 <= wptr;
            wptr_rclk_ff2 <= wptr_rclk_ff1;
        end
    end

    //--------------------------------------
    // Read pointer synchronized into write clock domain (binary)
    //--------------------------------------
    wire [PTR_WIDTH:0] rptr_sync_wclk_bin = gray2bin(rptr_wclk_ff2);

    //--------------------------------------
    // Write pointer synchronized into read clock domain (binary)
    //--------------------------------------
    wire [PTR_WIDTH:0] wptr_sync_rclk_bin = gray2bin(wptr_rclk_ff2);

    //--------------------------------------
    // Generate wfull flag (write side)
    // Full when next write pointer equals read pointer synchronized into write clk domain with 
    // MSB bits inverted as per FIFO full condition:
    //--------------------------------------
    // To check full, next write pointer gray code should be equal to read pointer gray code with MSB and 
    // the next MSB inverted
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_WIDTH:0] wptr_next_gray = bin2gray(wptr_bin_next);

    // Full condition:
    // The write pointer is one ahead of the read pointer in Gray code with MSB and MSB-1 bits inverted.
    // That is: wptr_next_gray[PTR_WIDTH:PTR_WIDTH-1] = ~rptr_wclk_ff2[PTR_WIDTH:PTR_WIDTH-1]
    // and the rest bits equal.

    wire full_condition = (wptr_next_gray[PTR_WIDTH-2:0] == rptr_wclk_ff2[PTR_WIDTH-2:0]) &&
                          (wptr_next_gray[PTR_WIDTH]   != rptr_wclk_ff2[PTR_WIDTH]) &&
                          (wptr_next_gray[PTR_WIDTH-1] != rptr_wclk_ff2[PTR_WIDTH-1]);

    assign wfull = full_condition;

    //--------------------------------------
    // Generate rempty flag (read side)
    // Empty when synchronized write pointer equals read pointer in Gray code.
    //--------------------------------------
    wire empty_condition = (rptr == wptr_rclk_ff2);
    assign rempty = empty_condition;

    //--------------------------------------
    // RAM write enable: write increment signal gated by not full
    //--------------------------------------
    assign wwrite_en = winc & (~wfull);

    //--------------------------------------
    // RAM read enable: read increment signal gated by not empty
    //--------------------------------------
    assign rread_en = rinc & (~rempty);

endmodule


// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]     wdata,
    input                  rclk,
    input                  renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    // RAM memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port (wclk domain)
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port (rclk domain)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule