`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                  wclk,    // Write clock
    input                  rclk,    // Read clock
    input                  wrstn,   // Write domain async reset (active low)
    input                  rrstn,   // Read domain async reset (active low)
    input                  winc,    // Write increment (push request)
    input                  rinc,    // Read increment (pop request)
    input      [WIDTH-1:0] wdata,   // Write data input
    output reg             wfull,   // Write full flag
    output reg             rempty,  // Read empty flag
    output reg [WIDTH-1:0] rdata    // Read data output
);

    // Address and pointer width calculation
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // One bit wider for full/empty flag logic

    // -------------------------
    // Binary and Gray-coded pointers
    // -------------------------

    // Write pointer (wclk domain)
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    wire wpush = winc & ~wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (wpush) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= (wptr_bin + 1'b1) ^ ((wptr_bin + 1'b1) >> 1);
        end
    end

    // Read pointer (rclk domain)
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    wire rpop = rinc & ~rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (rpop) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= (rptr_bin + 1'b1) ^ ((rptr_bin + 1'b1) >> 1);
        end
    end

    // -------------------------
    // Synchronizers for cross-domain pointers
    // -------------------------

    // Synchronize read pointer into write clock domain (to detect full)
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_w, rptr_gray_sync2_w;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_w <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync2_w <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync1_w <= rptr_gray;
            rptr_gray_sync2_w <= rptr_gray_sync1_w;
        end
    end

    // Synchronize write pointer into read clock domain (to detect empty)
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_r, wptr_gray_sync2_r;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_r <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync2_r <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync1_r <= wptr_gray;
            wptr_gray_sync2_r <= wptr_gray_sync1_r;
        end
    end

    // -------------------------
    // Functions: Gray to Binary and Binary to Gray conversion
    // -------------------------
    function [PTR_WIDTH-1:0] gray_to_bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray_to_bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] bin_to_gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin_to_gray = (bin >> 1) ^ bin;
        end
    endfunction

    // -------------------------
    // Full and Empty flag logic (registered for glitch avoidance)
    // -------------------------

    // Full detection in write clock domain:
    // wfull when next wptr == read ptr with MSB and next MSB inverted (Gray domain)
    wire [PTR_WIDTH-1:0] rptr_gray_sync_w_inv;
    assign rptr_gray_sync_w_inv = {
        ~rptr_gray_sync2_w[PTR_WIDTH-1],
        ~rptr_gray_sync2_w[PTR_WIDTH-2],
        rptr_gray_sync2_w[PTR_WIDTH-3:0]
    };

    // Compare current wptr_gray and rptr_gray_sync_w_inv to detect full
    wire wfull_next = (wptr_gray == rptr_gray_sync_w_inv);

    // Empty detection in read clock domain:
    // rempty when read pointer equals synchronized write pointer (Gray domain)
    wire rempty_next = (rptr_gray == wptr_gray_sync2_r);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= wfull_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= rempty_next;
    end

    // -------------------------
    // RAM port signals
    // -------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire wram_en = wpush;
    wire rram_en = rpop;

    wire [WIDTH-1:0] ram_rdata;

    // -------------------------
    // Dual-port RAM instance
    // -------------------------
    async_fifo_dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wram_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rram_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -------------------------
    // Read data registered in read domain after read enable
    // -------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rram_en)
            rdata <= ram_rdata;
    end

endmodule


// ---------------------------------------------------------------------------------------
// Dual-port RAM behavioral model with separate clocks and independent read/write enables
// Renamed to async_fifo_dual_port_ram to avoid module name conflicts in integration
// ---------------------------------------------------------------------------------------
module async_fifo_dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wire                    wclk,
    input  wire                    wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]        wdata,
    input  wire                    rclk,
    input  wire                    renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]        rdata
);

    // Storage array for FIFO data
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule