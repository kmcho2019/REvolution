`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,   // write clock domain
    input                  rclk,   // read clock domain
    input                  wrstn,  // async active low reset write domain
    input                  rrstn,  // async active low reset read domain
    input                  winc,   // write increment (push)
    input                  rinc,   // read increment (pop)
    input  [WIDTH-1:0]     wdata,  // data input for write
    output                 wfull,  // fifo full signal
    output                 rempty, // fifo empty signal
    output reg [WIDTH-1:0] rdata   // data output for read
);

    // Number of address bits (pointer width)
    localparam PTR_WIDTH = $clog2(DEPTH);

    // Gray code width (one bit wider for detecting full)
    localparam GRAY_WIDTH = PTR_WIDTH + 1;

    // ----------------------------------------------------------------------------
    // Internal registers and wires
    // ----------------------------------------------------------------------------

    // Write domain binary pointer (PTR_WIDTH+1 bits)
    reg [PTR_WIDTH:0] wptr_bin;

    // Read domain binary pointer (PTR_WIDTH+1 bits)
    reg [PTR_WIDTH:0] rptr_bin;

    // Write pointer in Gray code (synchronized to read clock domain)
    reg [GRAY_WIDTH-1:0] wptr_gray;

    // Read pointer in Gray code (synchronized to write clock domain)
    reg [GRAY_WIDTH-1:0] rptr_gray;

    // Synchronizers for pointers crossing domains (two-stage flip-flops)
    reg [GRAY_WIDTH-1:0] rptr_gray_wclk_ff1, rptr_gray_wclk_ff2;
    reg [GRAY_WIDTH-1:0] wptr_gray_rclk_ff1, wptr_gray_rclk_ff2;

    // Write and read addresses (lower PTR_WIDTH bits of binary pointers)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write enable gated by ~full
    wire w_en = winc & (~wfull);
    // Read enable gated by ~empty
    wire r_en = rinc & (~rempty);

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    // ----------------------------------------------------------------------------
    // Function: Binary to Gray code conversion for PTR_WIDTH+1 bit inputs
    // ----------------------------------------------------------------------------
    function [GRAY_WIDTH-1:0] bin_to_gray;
        input [PTR_WIDTH:0] bin;
        integer i;
        begin
            bin_to_gray[GRAY_WIDTH-1] = bin[PTR_WIDTH];
            for(i = PTR_WIDTH-1; i >= 0; i = i - 1)
                bin_to_gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // ----------------------------------------------------------------------------
    // Function: Gray code to binary conversion for PTR_WIDTH+1 bit outputs
    // ----------------------------------------------------------------------------
    function [PTR_WIDTH:0] gray_to_bin;
        input [GRAY_WIDTH-1:0] gray;
        integer j;
        begin
            gray_to_bin[PTR_WIDTH] = gray[GRAY_WIDTH-1];
            for (j = PTR_WIDTH-1; j >= 0; j = j - 1)
                gray_to_bin[j] = gray_to_bin[j+1] ^ gray[j];
        end
    endfunction

    // ----------------------------------------------------------------------------
    // Instantiate the dual-port RAM module
    // ----------------------------------------------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // ----------------------------------------------------------------------------
    // Write pointer update in write clock domain
    // ----------------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin_to_gray(wptr_bin + 1'b1);
        end
    end

    // ----------------------------------------------------------------------------
    // Read pointer update in read clock domain
    // ----------------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin_to_gray(rptr_bin + 1'b1);
        end
    end

    // ----------------------------------------------------------------------------
    // Synchronize read pointer (Gray) into write clock domain (2-stage synchronizer)
    // ----------------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_wclk_ff1 <= 0;
            rptr_gray_wclk_ff2 <= 0;
        end else begin
            rptr_gray_wclk_ff1 <= rptr_gray;
            rptr_gray_wclk_ff2 <= rptr_gray_wclk_ff1;
        end
    end

    // ----------------------------------------------------------------------------
    // Synchronize write pointer (Gray) into read clock domain (2-stage synchronizer)
    // ----------------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_rclk_ff1 <= 0;
            wptr_gray_rclk_ff2 <= 0;
        end else begin
            wptr_gray_rclk_ff1 <= wptr_gray;
            wptr_gray_rclk_ff2 <= wptr_gray_rclk_ff1;
        end
    end

    // ----------------------------------------------------------------------------
    // Convert synchronized Gray pointers back to binary for comparison
    // ----------------------------------------------------------------------------
    wire [PTR_WIDTH:0] rptr_bin_sync_wclk = gray_to_bin(rptr_gray_wclk_ff2);
    wire [PTR_WIDTH:0] wptr_bin_sync_rclk = gray_to_bin(wptr_gray_rclk_ff2);

    // ----------------------------------------------------------------------------
    // Full condition:
    // FIFO is full when the next write pointer equals read pointer with
    // MSB and next MSB inverted (classic async FIFO full detection).
    // ----------------------------------------------------------------------------
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [GRAY_WIDTH-1:0] wptr_gray_next = bin_to_gray(wptr_bin_next);

    wire full_condition =
        (wptr_gray_next[GRAY_WIDTH-3:0] == rptr_gray_wclk_ff2[GRAY_WIDTH-3:0]) &&
        (wptr_gray_next[GRAY_WIDTH-1] != rptr_gray_wclk_ff2[GRAY_WIDTH-1]) &&
        (wptr_gray_next[GRAY_WIDTH-2] != rptr_gray_wclk_ff2[GRAY_WIDTH-2]);

    assign wfull = full_condition;

    // ----------------------------------------------------------------------------
    // Empty condition:
    // FIFO is empty when read pointer equals synchronized write pointer.
    // ----------------------------------------------------------------------------
    assign rempty = (rptr_gray == wptr_gray_rclk_ff2);

    // ----------------------------------------------------------------------------
    // Register read data output on read enable for stable output
    // ----------------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

endmodule


// ----------------------------------------------------
// Dual-port RAM with independent read/write clocks
// ----------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                      rclk,
    input                      renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    // RAM memory declaration
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