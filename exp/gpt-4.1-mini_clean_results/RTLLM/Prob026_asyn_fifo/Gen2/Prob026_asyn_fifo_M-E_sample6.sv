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
    input       [WIDTH-1:0] wdata,
    output                  wfull,
    output                  rempty,
    output reg  [WIDTH-1:0] rdata
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // extra bit for full/empty distinction

    // -------------------------
    // Binary pointers for write
    // -------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc & ~wfull);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    // -------------------------
    // Binary pointers for read
    // -------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc & ~rempty);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    // -------------------------
    // Convert binary to Gray code for synchronization
    // -------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // -------------------------
    // Synchronize pointers to opposite clock domains (2-stage synchronizers)
    // -------------------------

    // Sync read pointer into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync_0, rptr_gray_wclk_sync_1;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync_0 <= 0;
            rptr_gray_wclk_sync_1 <= 0;
        end else begin
            rptr_gray_wclk_sync_0 <= rptr_gray;
            rptr_gray_wclk_sync_1 <= rptr_gray_wclk_sync_0;
        end
    end

    // Sync write pointer into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync_0, wptr_gray_rclk_sync_1;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync_0 <= 0;
            wptr_gray_rclk_sync_1 <= 0;
        end else begin
            wptr_gray_rclk_sync_0 <= wptr_gray;
            wptr_gray_rclk_sync_1 <= wptr_gray_rclk_sync_0;
        end
    end

    wire [PTR_WIDTH-1:0] rptr_gray_wclk_sync = rptr_gray_wclk_sync_1;
    wire [PTR_WIDTH-1:0] wptr_gray_rclk_sync = wptr_gray_rclk_sync_1;

    // -------------------------
    // Gray to binary conversion for RAM addressing
    // -------------------------
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    wire [PTR_WIDTH-1:0] rptr_bin_sync = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] wptr_bin_sync = gray2bin(wptr_gray_rclk_sync);

    // -------------------------
    // Generate empty and full signals
    // -------------------------
    // FIFO empty when read pointer equals synchronized write pointer in read domain
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

    // FIFO full when write pointer equals read pointer with top two bits inverted in write domain
    wire [PTR_WIDTH-1:0] rptr_gray_inv_top2;
    assign rptr_gray_inv_top2 = {~rptr_gray_wclk_sync[PTR_WIDTH-1], ~rptr_gray_wclk_sync[PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray == rptr_gray_inv_top2);

    // -------------------------
    // Addresses for RAM ports (use lower bits of binary pointers)
    // -------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable and read enable signals
    wire w_en = winc & (~wfull);
    wire r_en = rinc & (~rempty);

    wire [WIDTH-1:0] rdata_ram;

    // -------------------------
    // Dual port RAM instantiation
    // -------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(rdata_ram)
    );

    // Register read data at read clock domain (align with r_en)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= rdata_ram;
        end
    end

endmodule

// -----------------------------------------------------------------
// Dual Port RAM with Separate Clocks & Enables
// -----------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input       [$clog2(DEPTH)-1:0] waddr,
    input       [WIDTH-1:0]     wdata,
    input                       rclk,
    input                       renc,
    input       [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]     rdata
);

    // RAM memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: synchronous write on wclk when enabled
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port: synchronous read on rclk when enabled
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule