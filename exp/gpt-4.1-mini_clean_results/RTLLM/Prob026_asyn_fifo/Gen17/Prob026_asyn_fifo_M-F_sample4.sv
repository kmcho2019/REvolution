`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // active low reset for write domain
    input                   rrstn,   // active low reset for read domain
    input                   winc,    // write increment (write enable)
    input                   rinc,    // read increment (read enable)
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1;

    // Binary to Gray code (simple XOR with right-shifted value)
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to binary conversion for PTR_EXT bits (no loops, manual unroll)
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin;
    begin
        bin[PTR_EXT-1] = gray[PTR_EXT-1];
        for(i = PTR_EXT-2; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
        gray2bin = bin;
    end
    endfunction

    // Write pointer and Gray code registers
    reg [PTR_EXT-1:0] wptr_bin = 0;
    reg [PTR_EXT-1:0] wptr_gray = 0;

    // Read pointer and Gray code registers
    reg [PTR_EXT-1:0] rptr_bin = 0;
    reg [PTR_EXT-1:0] rptr_gray = 0;

    // Write pointer increment logic
    wire w_en = winc && !wfull;
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + (w_en ? 1'b1 : 1'b0);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // Read pointer increment logic
    wire r_en = rinc && !rempty;
    wire [PTR_EXT-1:0] rptr_bin_next = rptr_bin + (r_en ? 1'b1 : 1'b0);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // Synchronize read pointer into write clock domain
    reg [PTR_EXT-1:0] rptr_gray_wclk_meta = 0, rptr_gray_wclk_sync = 0;
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
    reg [PTR_EXT-1:0] wptr_gray_rclk_meta = 0, wptr_gray_rclk_sync = 0;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Convert synchronized Gray pointers back to binary for address generation
    wire [PTR_EXT-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_EXT-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk_sync);

    // Extract addresses for RAM ports (lower PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Full condition:
    // FIFO is full if write pointer equals read pointer with top two bits inverted
    assign wfull = (wptr_gray == {~rptr_gray_wclk_sync[PTR_EXT-1:PTR_EXT-2], rptr_gray_wclk_sync[PTR_EXT-3:0]});

    // Empty condition:
    // FIFO is empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    // Register output read data on rclk only when reading and FIFO not empty
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM with unique module name to avoid conflicts
    async_fifo_dp_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

endmodule


// Dual-port RAM submodule renamed to async_fifo_dp_ram to avoid conflicts
module async_fifo_dp_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]      wdata,
    input                       rclk,
    input                       renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end
endmodule