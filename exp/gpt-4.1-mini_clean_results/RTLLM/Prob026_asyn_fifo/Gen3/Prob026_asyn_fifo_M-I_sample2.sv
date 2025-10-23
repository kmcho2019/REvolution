`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,   // write clock domain
    input                  rclk,   // read clock domain
    input                  wrstn,  // async active low reset write domain (0 = reset)
    input                  rrstn,  // async active low reset read domain (0 = reset)
    input                  winc,   // write increment (push)
    input                  rinc,   // read increment (pop)
    input  [WIDTH-1:0]     wdata,  // data input for write
    output                 wfull,  // fifo full signal
    output                 rempty, // fifo empty signal
    output reg [WIDTH-1:0] rdata   // data output for read
);

    // Check DEPTH is power of two for correct pointer wrap & Gray code usage
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be a power of two for Gray code pointer logic.");
        end
    end

    // Number of address bits (pointer width)
    localparam PTR_WIDTH = $clog2(DEPTH);

    // Gray code width (one bit wider for full detection)
    localparam GRAY_WIDTH = PTR_WIDTH + 1;

    // ----------------------------------------------------------------------------
    // Internal registers and wires
    // ----------------------------------------------------------------------------

    // Write domain binary pointer (PTR_WIDTH+1 bits)
    reg [PTR_WIDTH:0] wptr_bin;

    // Read domain binary pointer (PTR_WIDTH+1 bits)
    reg [PTR_WIDTH:0] rptr_bin;

    // Write pointer in Gray code
    reg [GRAY_WIDTH-1:0] wptr_gray;

    // Read pointer in Gray code
    reg [GRAY_WIDTH-1:0] rptr_gray;

    // Two-stage synchronizer registers for read pointer in write clock domain
    (* ASYNC_REG = "true" *) reg [GRAY_WIDTH-1:0] rptr_gray_wclk_ff1, rptr_gray_wclk_ff2;

    // Two-stage synchronizer registers for write pointer in read clock domain
    (* ASYNC_REG = "true" *) reg [GRAY_WIDTH-1:0] wptr_gray_rclk_ff1, wptr_gray_rclk_ff2;

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
    // Function: Binary to Gray code conversion
    // ----------------------------------------------------------------------------
    function [GRAY_WIDTH-1:0] bin_to_gray(input [PTR_WIDTH:0] bin);
        integer i;
        begin
            bin_to_gray[GRAY_WIDTH-1] = bin[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                bin_to_gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // ----------------------------------------------------------------------------
    // Function: Gray code to binary conversion
    // ----------------------------------------------------------------------------
    function [PTR_WIDTH:0] gray_to_bin(input [GRAY_WIDTH-1:0] gray);
        integer j;
        begin
            gray_to_bin[PTR_WIDTH] = gray[GRAY_WIDTH-1];
            for (j = PTR_WIDTH-1; j >= 0; j = j - 1)
                gray_to_bin[j] = gray_to_bin[j+1] ^ gray[j];
        end
    endfunction

    // ----------------------------------------------------------------------------
    // Instantiate renamed dual-port RAM module to avoid name collision
    // ----------------------------------------------------------------------------
    asyn_fifo_dual_port_RAM #(
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
    // Write pointer update (write clock domain)
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
    // Read pointer update (read clock domain)
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

    // ----------------------------------------------------------------------------
    // Calculate the full condition
    // FIFO is full when the write pointer is one ahead of the read pointer with the MSB and
    // the next MSB inverted, and the other bits equal, based on Gray code properties.
    // ----------------------------------------------------------------------------
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire full_condition =
        (wptr_bin_next[PTR_WIDTH]     != rptr_bin_sync_wclk[PTR_WIDTH])     && // MSB differs
        (wptr_bin_next[PTR_WIDTH-1]   != rptr_bin_sync_wclk[PTR_WIDTH-1])   && // next MSB differs
        (wptr_bin_next[PTR_WIDTH-2:0] == rptr_bin_sync_wclk[PTR_WIDTH-2:0]);   // lower bits equal

    assign wfull = full_condition;

    // ----------------------------------------------------------------------------
    // Empty condition:
    // FIFO is empty when read pointer equals synchronized write pointer Gray code
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
// Renamed Dual-port RAM with independent read/write clocks
// ----------------------------------------------------
module asyn_fifo_dual_port_RAM #(
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