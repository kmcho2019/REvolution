`timescale 1ns / 1ps

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
    output reg [WIDTH-1:0]  rdata
);

    // Derived parameters
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam ADDR_WIDTH = PTR_WIDTH;
    localparam PTR_BITS = PTR_WIDTH + 1;  // For extra bit in Gray code pointers

    // -------- Binary Counters for Write and Read Pointers --------
    reg [PTR_BITS-1:0] wbin, rbin;
    wire [PTR_BITS-1:0] wbin_next = wbin + (winc & ~wfull);
    wire [PTR_BITS-1:0] rbin_next = rbin + (rinc & ~rempty);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wbin <= 0;
        else
            wbin <= wbin_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rbin <= 0;
        else
            rbin <= rbin_next;
    end

    // -------- Gray Code Conversion --------
    function [PTR_BITS-1:0] bin2gray(input [PTR_BITS-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    function [PTR_BITS-1:0] gray2bin(input [PTR_BITS-1:0] gray);
        integer i;
        reg [PTR_BITS-1:0] bin_tmp;
        begin
            bin_tmp[PTR_BITS-1] = gray[PTR_BITS-1];
            for (i = PTR_BITS-2; i >= 0; i = i -1)
                bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
            gray2bin = bin_tmp;
        end
    endfunction

    wire [PTR_BITS-1:0] wptr_gray = bin2gray(wbin);
    wire [PTR_BITS-1:0] rptr_gray = bin2gray(rbin);

    // -------- Two-Stage Synchronizers --------
    // Synchronize read pointer (gray) into write clock domain
    reg [PTR_BITS-1:0] rptr_gray_sync1, rptr_gray_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Synchronize write pointer (gray) into read clock domain
    reg [PTR_BITS-1:0] wptr_gray_sync1, wptr_gray_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // -------- Convert synchronized Gray pointers back to binary --------
    wire [PTR_BITS-1:0] rptr_sync_wclk_bin = gray2bin(rptr_gray_sync2);
    wire [PTR_BITS-1:0] wptr_sync_rclk_bin = gray2bin(wptr_gray_sync2);

    // -------- Full and Empty Flag Logic --------
    // FIFO is full when write pointer's binary is next to read pointer with top two bits inverted and lower bits equal
    wire full_cond = ((wbin_next[PTR_BITS-1]     != rptr_sync_wclk_bin[PTR_BITS-1]) &&
                      (wbin_next[PTR_BITS-2]   != rptr_sync_wclk_bin[PTR_BITS-2]) &&
                      (wbin_next[PTR_BITS-3:0] == rptr_sync_wclk_bin[PTR_BITS-3:0]));

    // FIFO is empty when read pointer equals synchronized write pointer
    wire empty_cond = (rbin == wptr_sync_rclk_bin);

    assign wfull = full_cond;
    assign rempty = empty_cond;

    // -------- RAM Addresses from lower PTR_WIDTH bits --------
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // -------- Write and Read Enables --------
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // -------- Dual-port RAM --------
    wire [WIDTH-1:0] ram_rdata;

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

    // -------- Register read data --------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= 0;
        else if (r_en)
            rdata <= ram_rdata;
    end

endmodule


// ---------------------------
// Dual-port RAM module with independent clocks and enables
// ---------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]          wdata,
    input                       rclk,
    input                       renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule