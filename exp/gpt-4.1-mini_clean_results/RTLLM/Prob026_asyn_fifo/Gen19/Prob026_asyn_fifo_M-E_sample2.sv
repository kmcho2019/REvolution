`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input               wclk,   // Write clock domain
    input               rclk,   // Read clock domain
    input               wrstn,  // Active low reset, write domain
    input               rrstn,  // Active low reset, read domain
    input               winc,   // Write increment (write enable)
    input               rinc,   // Read increment (read enable)
    input  [WIDTH-1:0]  wdata,  // Write data input
    output              wfull,  // FIFO full flag (write domain)
    output              rempty, // FIFO empty flag (read domain)
    output reg [WIDTH-1:0] rdata // Read data output
);

    // Calculate address width based on DEPTH (assumed power of 2)
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Binary pointers are ADDR_WIDTH+1 to detect wrap-around
    reg [ADDR_WIDTH:0] wbin = 0;
    reg [ADDR_WIDTH:0] rbin = 0;

    // Gray code pointers
    reg [ADDR_WIDTH:0] wptr = 0;
    reg [ADDR_WIDTH:0] rptr = 0;

    // Synchronized Gray pointers for crossing clock domains
    reg [ADDR_WIDTH:0] rptr_wclk_sync1 = 0, rptr_wclk_sync2 = 0; // read ptr synchronized into write clk
    reg [ADDR_WIDTH:0] wptr_rclk_sync1 = 0, wptr_rclk_sync2 = 0; // write ptr synchronized into read clk

    // Write enable is valid when not full
    wire w_en = winc & ~wfull;

    // Read enable is valid when not empty
    wire r_en = rinc & ~rempty;

    // Binary to Gray function
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        integer i;
        begin
            bin2gray[ADDR_WIDTH] = bin[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to Binary function
    function [ADDR_WIDTH:0] gray2bin(input [ADDR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write Pointer Logic (Write clock domain)
    wire [ADDR_WIDTH:0] wbin_next = wbin + (w_en ? 1'b1 : 1'b0);
    wire [ADDR_WIDTH:0] wptr_next = bin2gray(wbin_next);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wptr <= 0;
            rptr_wclk_sync1 <= 0;
            rptr_wclk_sync2 <= 0;
        end else begin
            // Update write pointer binary and Gray on write enable
            if (w_en) begin
                wbin <= wbin_next;
                wptr <= wptr_next;
            end
            // Synchronize read pointer (Gray) into write clock domain
            rptr_wclk_sync1 <= rptr;
            rptr_wclk_sync2 <= rptr_wclk_sync1;
        end
    end

    // Read Pointer Logic (Read clock domain)
    wire [ADDR_WIDTH:0] rbin_next = rbin + (r_en ? 1'b1 : 1'b0);
    wire [ADDR_WIDTH:0] rptr_next = bin2gray(rbin_next);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rptr <= 0;
            wptr_rclk_sync1 <= 0;
            wptr_rclk_sync2 <= 0;
            rdata <= 0;
        end else begin
            // Update read pointer binary and Gray on read enable
            if (r_en) begin
                rbin <= rbin_next;
                rptr <= rptr_next;
            end
            // Synchronize write pointer (Gray) into read clock domain
            wptr_rclk_sync1 <= wptr;
            wptr_rclk_sync2 <= wptr_rclk_sync1;

            // Capture read data from RAM at read address on read clock and read enable
            if (r_en) begin
                rdata <= ram_rdata;
            end
        end
    end

    // Convert synchronized pointers back to binary for comparison
    wire [ADDR_WIDTH:0] rbin_wclk_sync = gray2bin(rptr_wclk_sync2);
    wire [ADDR_WIDTH:0] wbin_rclk_sync = gray2bin(wptr_rclk_sync2);

    // Address to RAM uses lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // Full detection logic: 
    // FIFO full if next write pointer = read pointer with MSBs inverted
    // Condition: wptr_next[ADDR_WIDTH] != rptr_wclk_sync2[ADDR_WIDTH]
    //         && wptr_next[ADDR_WIDTH-1] != rptr_wclk_sync2[ADDR_WIDTH-1]
    //         && lower bits equal
    assign wfull = ( (wptr_next[ADDR_WIDTH]     != rptr_wclk_sync2[ADDR_WIDTH]) &&
                     (wptr_next[ADDR_WIDTH-1]   != rptr_wclk_sync2[ADDR_WIDTH-1]) &&
                     (wptr_next[ADDR_WIDTH-2:0] == rptr_wclk_sync2[ADDR_WIDTH-2:0]) );

    // Empty detection logic:
    // FIFO empty when read pointer equals synchronized write pointer
    assign rempty = (rptr == wptr_rclk_sync2);

    // Instantiate the dual-port RAM module
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

endmodule


// Dual-Port RAM module with separate read and write clocks
module dual_port_RAM #(
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

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation (synchronous with wclk)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read operation (synchronous with rclk)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule