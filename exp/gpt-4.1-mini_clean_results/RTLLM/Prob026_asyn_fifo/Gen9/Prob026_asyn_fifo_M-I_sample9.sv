`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,   // active low reset in write clock domain
    input                  rrstn,   // active low reset in read clock domain
    input                  winc,    // write increment (push) request
    input                  rinc,    // read increment (pop) request
    input      [WIDTH-1:0] wdata,
    output reg             wfull,
    output reg             rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);      // bits needed for addressing DEPTH locations
    localparam PTR_EXT = PTR_WIDTH + 1;        // extended pointer width including wrap bit

    // --- Signals for RAM access ---
    wire [PTR_WIDTH-1:0] waddr;
    wire [PTR_WIDTH-1:0] raddr;
    wire w_en;
    wire r_en;
    wire [WIDTH-1:0] ram_rdata;

    // Binary pointers
    reg [PTR_EXT-1:0] wptr_bin;
    reg [PTR_EXT-1:0] rptr_bin;

    // Gray pointers
    reg [PTR_EXT-1:0] wptr_gray;
    reg [PTR_EXT-1:0] rptr_gray;

    // Pointer synchronizers: crossing clock domains
    wire [PTR_EXT-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT-1:0] wptr_gray_sync_rclk;

    // Write and read enables gated by full/empty flags
    assign w_en = winc & ~wfull;
    assign r_en = rinc & ~rempty;

    assign waddr = wptr_bin[PTR_WIDTH-1:0];
    assign raddr = rptr_bin[PTR_WIDTH-1:0];

    // --- Conversion functions ---

    // Binary to Gray code conversion
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_EXT-1] = bin[PTR_EXT-1];
            for(i = PTR_EXT-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray code to Binary conversion
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for (i=PTR_EXT-2; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // --- Write pointer logic ---
    // Next write binary pointer
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + {{PTR_EXT-1{1'b0}}, 1'b1};

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // --- Read pointer logic ---
    // Next read binary pointer
    wire [PTR_EXT-1:0] rptr_bin_next = rptr_bin + {{PTR_EXT-1{1'b0}}, 1'b1};

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // --- Pointer synchronizers ---
    // Synchronize read pointer into write clock domain
    ptr_sync #(PTR_EXT) read_ptr_sync_inst (
        .clk(wclk),
        .rst_n(wrstn),
        .async_ptr(rptr_gray),
        .sync_ptr(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer into read clock domain
    ptr_sync #(PTR_EXT) write_ptr_sync_inst (
        .clk(rclk),
        .rst_n(rrstn),
        .async_ptr(wptr_gray),
        .sync_ptr(wptr_gray_sync_rclk)
    );

    // --- FIFO full detection (in write clock domain) ---
    // The FIFO is full when the next write pointer equals the read pointer with MSB and next MSB inverted
    wire full_w = 
        (wptr_bin_next[PTR_WIDTH-1:0] == gray2bin(rptr_gray_sync_wclk)[PTR_WIDTH-1:0]) && 
        (wptr_bin_next[PTR_EXT-1:PTR_WIDTH] == ~gray2bin(rptr_gray_sync_wclk)[PTR_EXT-1:PTR_WIDTH]);

    // --- FIFO empty detection (in read clock domain) ---
    wire empty_r = (rptr_gray == wptr_gray_sync_rclk);

    // Register full and empty flags for glitch-free outputs
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_w;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_r;
    end

    // --- Read data output ---
    // Registered output updated on read enable
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // --- Dual-port RAM instance ---
    async_fifo_dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram (
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


// ------------------------------------------------------------------
// Pointer Synchronizer Module:
// Two-stage synchronizer for multi-bit Gray code pointer crossing clock domains
module ptr_sync #(
    parameter PTR_WIDTH = 5
)(
    input                  clk,
    input                  rst_n,
    input  [PTR_WIDTH-1:0] async_ptr,
    output reg [PTR_WIDTH-1:0] sync_ptr
);
    reg [PTR_WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= 0;
            sync_ptr <= 0;
        end else begin
            sync_ff1 <= async_ptr;
            sync_ptr <= sync_ff1;
        end
    end
endmodule


// ------------------------------------------------------------------
// Dual-Port RAM Module for Asynchronous FIFO Storage
// Write port clocked by wclk, read port clocked by rclk
// Write enable and read enable signals provided
module async_fifo_dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0] wdata,
    input                  rclk,
    input                  renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    // RAM memory array
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write port: synchronous write
    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    // Read port: synchronous read
    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule