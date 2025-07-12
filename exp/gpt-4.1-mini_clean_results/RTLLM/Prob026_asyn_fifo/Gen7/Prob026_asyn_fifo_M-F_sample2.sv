`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low reset for write domain
    input                   rrstn,      // active low reset for read domain
    input                   winc,       // write increment request
    input                   rinc,       // read increment request
    input  [WIDTH-1:0]      wdata,
    output reg              wfull,
    output reg              rempty,
    output reg [WIDTH-1:0]  rdata
);

    // Pointer width = address width + 1 extra bit for full/empty distinction
    localparam PTR_WIDTH = $clog2(DEPTH) + 1;
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Check DEPTH is a power of two at elaboration time
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be a power of two");
        end
    end

    // ---------------------------
    // Write pointer logic (write clock domain)
    // ---------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Calculate next write pointer binary and Gray
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc & ~wfull);
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            if (winc & ~wfull) begin
                wptr_bin <= wptr_bin_next;
                wptr_gray <= wptr_gray_next;
            end
        end
    end

    // ---------------------------
    // Read pointer logic (read clock domain)
    // ---------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc & ~rempty);
    wire [PTR_WIDTH-1:0] rptr_gray_next = bin2gray(rptr_bin_next);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            if (rinc & ~rempty) begin
                rptr_bin <= rptr_bin_next;
                rptr_gray <= rptr_gray_next;
            end
        end
    end

    // ---------------------------
    // Synchronize pointers across clock domains
    // ---------------------------

    // Sync read pointer into write clock domain (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Sync write pointer into read clock domain (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Convert synchronized pointers back to binary
    wire [PTR_WIDTH-1:0] rptr_sync_bin_wclk = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] wptr_sync_bin_rclk = gray2bin(wptr_gray_rclk_sync);

    // ---------------------------
    // Full flag generation (write clock domain)
    // FIFO is full when next write pointer equals read pointer synchronized into write domain with top two bits inverted and rest equal
    // This corresponds to the write pointer being exactly one lap ahead of read pointer in Gray code space.
    // Full when:
    // (wptr_gray_next[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_wclk_sync[PTR_WIDTH-1:PTR_WIDTH-2]) &&
    // (wptr_gray_next[PTR_WIDTH-3:0] == rptr_gray_wclk_sync[PTR_WIDTH-3:0])
    // ---------------------------

    wire full_cond_top_bits_inv = 
          (wptr_gray_next[PTR_WIDTH-1]     == ~rptr_gray_wclk_sync[PTR_WIDTH-1]) &&
          (wptr_gray_next[PTR_WIDTH-2]     == ~rptr_gray_wclk_sync[PTR_WIDTH-2]);

    wire full_cond_lower_bits_eq =
          (wptr_gray_next[PTR_WIDTH-3:0] == rptr_gray_wclk_sync[PTR_WIDTH-3:0]);

    wire wfull_int = full_cond_top_bits_inv && full_cond_lower_bits_eq;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= wfull_int;
        end
    end

    // ---------------------------
    // Empty flag generation (read clock domain)
    // FIFO is empty when synchronized write pointer equals read pointer
    // ---------------------------
    wire empty_flag = (rptr_gray == wptr_gray_rclk_sync);
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= empty_flag;
        end
    end

    // ---------------------------
    // RAM address calculation: use lower ADDR_WIDTH bits of binary pointers
    // ---------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // ---------------------------
    // Read data wire from RAM
    // ---------------------------
    wire [WIDTH-1:0] ram_rdata;

    // Register read data output on rclk
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (rinc & ~rempty) begin
            rdata <= ram_rdata;
        end
    end

    // Write enable and read enable signals
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // ---------------------------
    // Instantiate dual-port RAM (assumed external)
    // ---------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_ram_inst (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );


    // ---------------------------
    // Function: binary to Gray code conversion
    // ---------------------------
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // ---------------------------
    // Function: Gray code to binary conversion
    // ---------------------------
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

endmodule