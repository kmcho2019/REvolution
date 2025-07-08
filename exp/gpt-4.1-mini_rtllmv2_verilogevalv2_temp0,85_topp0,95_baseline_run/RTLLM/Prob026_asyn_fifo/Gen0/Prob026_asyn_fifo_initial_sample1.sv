`timescale 1ns / 1ps
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire               wclk,
    input  wire               rclk,
    input  wire               wrstn,
    input  wire               rrstn,
    input  wire               winc,
    input  wire               rinc,
    input  wire [WIDTH-1:0]   wdata,
    output wire               wfull,
    output wire               rempty,
    output wire [WIDTH-1:0]   rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // Gray code pointer width (one extra bit)

    // Dual-port RAM instantiation
    wire wram_en;
    wire rram_en;
    wire [ADDR_WIDTH-1:0] wram_addr;
    wire [ADDR_WIDTH-1:0] rram_addr;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wram_en),
        .waddr(wram_addr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rram_en),
        .raddr(rram_addr),
        .rdata(rdata)
    );

    // Binary write pointer and Gray-coded write pointer
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    // Synchronized read pointer into write clock domain (Gray code)
    reg [PTR_WIDTH-1:0] rptr_gray_wclk, rptr_gray_wclk2;
    wire [PTR_WIDTH-1:0] rptr_gray_wclk_sync;

    // Binary read pointer and Gray-coded read pointer
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    // Synchronized write pointer into read clock domain (Gray code)
    reg [PTR_WIDTH-1:0] wptr_gray_rclk, wptr_gray_rclk2;
    wire [PTR_WIDTH-1:0] wptr_gray_rclk_sync;

    // Write pointer increment on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else begin
            if (winc && !wfull) begin
                wptr_bin <= wptr_bin + 1'b1;
                wptr_gray <= (wptr_bin + 1'b1) ^ ((wptr_bin + 1'b1) >> 1);
            end
        end
    end

    // Read pointer increment on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else begin
            if (rinc && !rempty) begin
                rptr_bin <= rptr_bin + 1'b1;
                rptr_gray <= (rptr_bin + 1'b1) ^ ((rptr_bin + 1'b1) >> 1);
            end
        end
    end

    // Synchronize read pointer Gray code into write clock domain (2-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk  <= 0;
            rptr_gray_wclk2 <= 0;
        end else begin
            rptr_gray_wclk  <= rptr_gray;
            rptr_gray_wclk2 <= rptr_gray_wclk;
        end
    end
    assign rptr_gray_wclk_sync = rptr_gray_wclk2;

    // Synchronize write pointer Gray code into read clock domain (2-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk  <= 0;
            wptr_gray_rclk2 <= 0;
        end else begin
            wptr_gray_rclk  <= wptr_gray;
            wptr_gray_rclk2 <= wptr_gray_rclk;
        end
    end
    assign wptr_gray_rclk_sync = wptr_gray_rclk2;

    // Convert Gray to Binary function
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Convert synchronized read pointer to binary in write clock domain
    wire [PTR_WIDTH-1:0] rptr_bin_wclk_sync;
    assign rptr_bin_wclk_sync = gray2bin(rptr_gray_wclk_sync);

    // Convert synchronized write pointer to binary in read clock domain
    wire [PTR_WIDTH-1:0] wptr_bin_rclk_sync;
    assign wptr_bin_rclk_sync = gray2bin(wptr_gray_rclk_sync);

    // Write address to RAM (lower ADDR_WIDTH bits of write pointer binary)
    assign wram_addr = wptr_bin[ADDR_WIDTH-1:0];
    // Read address to RAM (lower ADDR_WIDTH bits of read pointer binary)
    assign rram_addr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable RAM: only write when winc and not full
    assign wram_en = winc && !wfull;
    // Read enable RAM: only read when rinc and not empty
    assign rram_en = rinc && !rempty;

    // Full detection:
    // Full when:
    // (wptr_gray[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2]) 
    // and (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync[PTR_WIDTH-3:0])
    // For DEPTH=16, PTR_WIDTH=5, bits: [4:3] highest two bits, [2:0] lower bits
    wire full_cond;
    assign full_cond =
        ((wptr_gray[PTR_WIDTH-1]      != rptr_gray_wclk_sync[PTR_WIDTH-1]) &&
         (wptr_gray[PTR_WIDTH-2]      != rptr_gray_wclk_sync[PTR_WIDTH-2]) &&
         (wptr_gray[PTR_WIDTH-3:0]   == rptr_gray_wclk_sync[PTR_WIDTH-3:0]));

    assign wfull = full_cond;

    // Empty detection:
    // Empty when read pointer equals synchronized write pointer in read clock domain
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

endmodule


// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                 wclk,
    input  wire                 wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]     wdata,
    input  wire                 rclk,
    input  wire                 renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]     rdata
);

    // RAM storage
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port (write on rising edge of wclk if enabled)
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port (read on rising edge of rclk if enabled)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            rdata <= rdata; // hold previous value if not enabled
        end
    end

endmodule