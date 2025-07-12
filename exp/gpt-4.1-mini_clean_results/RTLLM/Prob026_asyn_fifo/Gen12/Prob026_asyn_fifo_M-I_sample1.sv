`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,   // Active low synchronous reset for write domain
    input                  rrstn,   // Active low synchronous reset for read domain
    input                  winc,    // Write enable
    input                  rinc,    // Read enable
    input  [WIDTH-1:0]     wdata,   // Data input
    output                 wfull,   // FIFO full indicator (write side)
    output                 rempty,  // FIFO empty indicator (read side)
    output reg [WIDTH-1:0] rdata    // Data output
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam EXT_PTR_WIDTH = PTR_WIDTH + 2; 
    // Extended pointer width includes 2 MSBs for full/empty detection

    // Write domain registers
    reg [EXT_PTR_WIDTH-1:0] wptr_bin;    // Binary write pointer
    reg [EXT_PTR_WIDTH-1:0] wptr_gray;   // Gray coded write pointer

    // Read domain registers
    reg [EXT_PTR_WIDTH-1:0] rptr_bin;    // Binary read pointer
    reg [EXT_PTR_WIDTH-1:0] rptr_gray;   // Gray coded read pointer

    // Pointer synchronizers (Gray code)
    reg [EXT_PTR_WIDTH-1:0] rptr_gray_sync_wclk_1, rptr_gray_sync_wclk;
    reg [EXT_PTR_WIDTH-1:0] wptr_gray_sync_rclk_1, wptr_gray_sync_rclk;

    // Internal RAM addresses (lowest PTR_WIDTH bits of binary pointers)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write and read enables gated by full/empty signals
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM output data
    wire [WIDTH-1:0] ram_rdata;

    // Write pointer update and Gray code generation (synchronous active-low reset)
    always @(posedge wclk) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer update and Gray code generation (synchronous active-low reset)
    always @(posedge rclk) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer gray into write clock domain (2-stage)
    always @(posedge wclk) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk_1 <= 0;
            rptr_gray_sync_wclk   <= 0;
        end else begin
            rptr_gray_sync_wclk_1 <= rptr_gray;
            rptr_gray_sync_wclk   <= rptr_gray_sync_wclk_1;
        end
    end

    // Synchronize write pointer gray into read clock domain (2-stage)
    always @(posedge rclk) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk_1 <= 0;
            wptr_gray_sync_rclk   <= 0;
        end else begin
            wptr_gray_sync_rclk_1 <= wptr_gray;
            wptr_gray_sync_rclk   <= wptr_gray_sync_rclk_1;
        end
    end

    // Convert synchronized Gray pointers back to binary for full/empty detection
    wire [EXT_PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [EXT_PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    // Next write pointer binary value
    wire [EXT_PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;

    // Full condition: 
    // MSBs (top 2 bits) of write pointer next are inverse of read pointer synced MSBs, rest equal
    wire full_cond_upper = (wptr_bin_next[EXT_PTR_WIDTH-1]     == ~rptr_bin_sync_wclk[EXT_PTR_WIDTH-1]) &&
                          (wptr_bin_next[EXT_PTR_WIDTH-2]     == ~rptr_bin_sync_wclk[EXT_PTR_WIDTH-2]);
    wire full_cond_lower = (wptr_bin_next[EXT_PTR_WIDTH-3:0] == rptr_bin_sync_wclk[EXT_PTR_WIDTH-3:0]);

    assign wfull = full_cond_upper && full_cond_lower;

    // Empty condition: read pointer equals synchronized write pointer in read clock domain
    assign rempty = (rptr_bin == wptr_bin_sync_rclk);

    // Register read data on read clock when reading
    always @(posedge rclk) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM with renamed module to avoid conflicts
    dual_port_ram_async #(
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

    // Binary to Gray code conversion function
    function [EXT_PTR_WIDTH-1:0] bin2gray;
        input [EXT_PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[EXT_PTR_WIDTH-1] = bin[EXT_PTR_WIDTH-1];
            for (i = EXT_PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to binary conversion function
    function [EXT_PTR_WIDTH-1:0] gray2bin;
        input [EXT_PTR_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[EXT_PTR_WIDTH-1] = gray[EXT_PTR_WIDTH-1];
            for (j = EXT_PTR_WIDTH-2; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

endmodule


// Renamed dual-port RAM module to avoid naming collisions
module dual_port_ram_async #(
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