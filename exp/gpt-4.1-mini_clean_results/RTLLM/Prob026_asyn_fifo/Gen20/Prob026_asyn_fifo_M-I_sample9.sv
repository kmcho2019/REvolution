`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,    // Write clock domain
    input                  rclk,    // Read clock domain
    input                  wrstn,   // Active low write domain reset
    input                  rrstn,   // Active low read domain reset
    input                  winc,    // Write increment enable
    input                  rinc,    // Read increment enable
    input  [WIDTH-1:0]     wdata,   // Write data input
    output                 wfull,   // FIFO full flag (write domain)
    output                 rempty,  // FIFO empty flag (read domain)
    output reg [WIDTH-1:0] rdata    // Read data output
);

    // Address width for DEPTH (must be power of 2)
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Binary pointers are ADDR_WIDTH+1 bits to detect wrap-around
    reg [ADDR_WIDTH:0] wbin = 0;
    reg [ADDR_WIDTH:0] rbin = 0;

    // Gray code pointers
    reg [ADDR_WIDTH:0] wptr = 0;
    reg [ADDR_WIDTH:0] rptr = 0;

    // Two-stage synchronizers for crossing clock domains
    reg [ADDR_WIDTH:0] rptr_wclk_sync1 = 0, rptr_wclk_sync2 = 0; // rptr synchronized into write clk
    reg [ADDR_WIDTH:0] wptr_rclk_sync1 = 0, wptr_rclk_sync2 = 0; // wptr synchronized into read clk

    // Write and read enables gated by full and empty flags
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Function: Binary to Gray code conversion (optimized)
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        begin
            // MSB unchanged, other bits are bin[i+1] XOR bin[i]
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Function: Gray to Binary conversion (optimized XOR tree)
    function [ADDR_WIDTH:0] gray2bin(input [ADDR_WIDTH:0] gray);
        integer i;
        reg [ADDR_WIDTH:0] bin_tmp;
        begin
            bin_tmp[ADDR_WIDTH] = gray[ADDR_WIDTH];
            // Propagate XORs downwards
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1)
                bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
            gray2bin = bin_tmp;
        end
    endfunction

    // --- Write pointer logic (write clock domain) ---
    wire [ADDR_WIDTH:0] wbin_next = wbin + (w_en ? 1'b1 : 1'b0);
    wire [ADDR_WIDTH:0] wptr_next = bin2gray(wbin_next);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wptr <= 0;
            rptr_wclk_sync1 <= 0;
            rptr_wclk_sync2 <= 0;
        end else begin
            if (w_en) begin
                wbin <= wbin_next;
                wptr <= wptr_next;
            end
            // Synchronize read pointer from read domain to write domain (two-stage)
            rptr_wclk_sync1 <= rptr;
            rptr_wclk_sync2 <= rptr_wclk_sync1;
        end
    end

    // --- Read pointer logic (read clock domain) ---
    wire [ADDR_WIDTH:0] rbin_next = rbin + (r_en ? 1'b1 : 1'b0);
    wire [ADDR_WIDTH:0] rptr_next = bin2gray(rbin_next);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rptr <= 0;
            wptr_rclk_sync1 <= 0;
            wptr_rclk_sync2 <= 0;
            rdata <= {WIDTH{1'b0}};
        end else begin
            if (r_en) begin
                rbin <= rbin_next;
                rptr <= rptr_next;
            end
            // Synchronize write pointer from write domain to read domain (two-stage)
            wptr_rclk_sync1 <= wptr;
            wptr_rclk_sync2 <= wptr_rclk_sync1;

            // Register read data on read enable for stable output
            if (r_en) 
                rdata <= ram_rdata;
        end
    end

    // Convert synchronized Gray pointers to binary for comparisons
    wire [ADDR_WIDTH:0] rbin_wclk_sync = gray2bin(rptr_wclk_sync2);
    wire [ADDR_WIDTH:0] wbin_rclk_sync = gray2bin(wptr_rclk_sync2);

    // RAM addresses: use lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // Full condition:
    // FIFO full when write pointer is one cycle ahead of read pointer with MSB and next MSB inverted, rest equal
    assign wfull = ( (wptr_next[ADDR_WIDTH]     != rptr_wclk_sync2[ADDR_WIDTH]) &&
                     (wptr_next[ADDR_WIDTH-1]   != rptr_wclk_sync2[ADDR_WIDTH-1]) &&
                     (wptr_next[ADDR_WIDTH-2:0] == rptr_wclk_sync2[ADDR_WIDTH-2:0]) );

    // Empty condition: read pointer equals synchronized write pointer
    assign rempty = (rptr == wptr_rclk_sync2);

    // Instantiate the dual-port RAM submodule
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

    // Internal wire for RAM read data
    wire [WIDTH-1:0] ram_rdata;

endmodule


// Dual-port RAM with independent clocks for read and write ports
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]         wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule