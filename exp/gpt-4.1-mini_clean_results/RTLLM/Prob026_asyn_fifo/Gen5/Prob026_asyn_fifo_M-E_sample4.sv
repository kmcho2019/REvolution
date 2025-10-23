`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,    // active low reset for write domain
    input                   rrstn,    // active low reset for read domain
    input                   winc,     // write increment
    input                   rinc,     // read increment
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);
    // Calculate pointer width for addressing DEPTH locations
    localparam PTR_WIDTH = $clog2(DEPTH);
    // DEPTH must be power of two for address pointer wraparound
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $fatal("DEPTH must be power of 2");
        end
    end

    // -----------------------
    // Binary pointers - write and read domain
    // -----------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // -----------------------
    // Gray pointers for synchronization
    // -----------------------
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // -----------------------
    // Synchronizer outputs (gray pointers synced into opposite clock domain)
    // -----------------------
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk; // read pointer synced to write clk
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk; // write pointer synced to read clk

    // -----------------------
    // Binary versions of synchronized Gray pointers (for full/empty detection)
    // -----------------------
    wire [PTR_WIDTH-1:0] rptr_sync_bin_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [PTR_WIDTH-1:0] wptr_sync_bin_rclk = gray2bin(wptr_gray_sync_rclk);

    // -----------------------
    // Write enable gated by FIFO not full
    // -----------------------
    wire w_en = winc & (~wfull);
    // Read enable gated by FIFO not empty
    wire r_en = rinc & (~rempty);

    // -----------------------
    // Next write pointer calculation
    // -----------------------
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;

    // -----------------------
    // Full condition:
    // FIFO is full when next write pointer equals read pointer with MSB bit toggled
    // This means write pointer has "lapped" read pointer by DEPTH positions
    // -----------------------
    wire full_flag;
    assign full_flag = ( (wptr_bin_next[PTR_WIDTH-1] != rptr_sync_bin_wclk[PTR_WIDTH-1]) &&
                         (wptr_bin_next[PTR_WIDTH-2:0] == rptr_sync_bin_wclk[PTR_WIDTH-2:0]) );

    assign wfull = full_flag;

    // -----------------------
    // Empty condition:
    // FIFO is empty when synchronized write pointer equals read pointer
    // -----------------------
    wire empty_flag;
    assign empty_flag = (rptr_bin == wptr_sync_bin_rclk);
    assign rempty = empty_flag;

    // -----------------------
    // Write pointer update (write clock domain)
    // -----------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
        end
    end

    // -----------------------
    // Read pointer update (read clock domain)
    // -----------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
        end
    end

    // -----------------------
    // Synchronize read pointer into write clock domain (Gray code)
    // -----------------------
    synchronizer #(
        .WIDTH(PTR_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    // -----------------------
    // Synchronize write pointer into read clock domain (Gray code)
    // -----------------------
    synchronizer #(
        .WIDTH(PTR_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // -----------------------
    // RAM addresses directly use binary pointers lower bits
    // -----------------------
    wire [PTR_WIDTH-1:0] waddr = wptr_bin;
    wire [PTR_WIDTH-1:0] raddr = rptr_bin;

    // -----------------------
    // Dual port RAM output data wire
    // -----------------------
    wire [WIDTH-1:0] ram_rdata;

    // -----------------------
    // Register output data on read clock when read enable
    // -----------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

    // -----------------------
    // Instantiate dual-port RAM
    // -----------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -----------------------
    // Functions for Gray code conversions
    // -----------------------
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(j=PTR_WIDTH-2; j>=0; j=j-1) begin
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
            end
        end
    endfunction

endmodule

// ---------------------------------------
// Two-stage synchronizer for multi-bit signals
// ---------------------------------------
module synchronizer #(
    parameter WIDTH = 4
)(
    input                  clk,
    input                  rst_n,
    input  [WIDTH-1:0]     in,
    output reg [WIDTH-1:0] out
);

    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sync_ff1 <= {WIDTH{1'b0}};
            out      <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= in;
            out      <= sync_ff1;
        end
    end

endmodule


// ---------------------------------------------
// Dual-port RAM with independent clocks, write enable and read enable
// ---------------------------------------------
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

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule