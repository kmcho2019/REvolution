`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,    // active low write domain reset
    input                 rrstn,    // active low read domain reset
    input                 winc,     // write increment pulse
    input                 rinc,     // read increment pulse
    input  [WIDTH-1:0]    wdata,    // data input for write
    output                wfull,    // FIFO full flag (write domain)
    output                rempty,   // FIFO empty flag (read domain)
    output reg [WIDTH-1:0] rdata    // data output from read side
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    // Binary pointers, extended with one MSB for wrap-around detection
    reg [PTR_WIDTH:0] wbin = 0;
    reg [PTR_WIDTH:0] rbin = 0;

    // Gray pointers corresponding to the binary pointers
    reg [PTR_WIDTH:0] wptr_gray = 0;
    reg [PTR_WIDTH:0] rptr_gray = 0;

    // Synchronized pointers (Gray code) crossing clock domains
    wire [PTR_WIDTH:0] rptr_gray_sync_wclk;
    wire [PTR_WIDTH:0] wptr_gray_sync_rclk;

    // Calculate next write pointer in binary and gray
    wire [PTR_WIDTH:0] wbin_next = wbin + 1'b1;
    wire [PTR_WIDTH:0] wptr_gray_next = bin2gray(wbin_next);

    // Write enable gated by not full
    wire w_en = winc & ~wfull;
    // Read enable gated by not empty
    wire r_en = rinc & ~rempty;

    // RAM addresses derived from binary pointers (lowest PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr = wbin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rbin[PTR_WIDTH-1:0];

    // RAM data output wire
    wire [WIDTH-1:0] ram_rdata;

    // Convert binary to gray code
    function [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH] = bin[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Convert gray code to binary
    function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer increment and Gray conversion (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wbin <= wbin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Read pointer increment and Gray conversion (read clock domain)
    wire [PTR_WIDTH:0] rbin_next = rbin + 1'b1;
    wire [PTR_WIDTH:0] rptr_gray_next = bin2gray(rbin_next);
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rbin <= rbin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Instantiate synchronizers for crossing clock domains:
    // Read pointer synchronized into write clock domain
    ptr_sync #(
        .WIDTH(PTR_WIDTH+1)
    ) rptr_sync_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .async_ptr_in(rptr_gray),
        .sync_ptr_out(rptr_gray_sync_wclk)
    );

    // Write pointer synchronized into read clock domain
    ptr_sync #(
        .WIDTH(PTR_WIDTH+1)
    ) wptr_sync_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .async_ptr_in(wptr_gray),
        .sync_ptr_out(wptr_gray_sync_rclk)
    );

    // Convert synchronized pointers back to binary for status checks
    wire [PTR_WIDTH:0] rbin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [PTR_WIDTH:0] wbin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    // FIFO full detection (write clock domain)
    // FIFO is full when next write pointer equals read pointer with top two bits inverted:
    assign wfull = (wptr_gray_next[PTR_WIDTH]     != rptr_gray_sync_wclk[PTR_WIDTH]) &&
                   (wptr_gray_next[PTR_WIDTH-1]   != rptr_gray_sync_wclk[PTR_WIDTH-1]) &&
                   (wptr_gray_next[PTR_WIDTH-2:0] == rptr_gray_sync_wclk[PTR_WIDTH-2:0]);

    // FIFO empty detection (read clock domain)
    // FIFO empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Register read data on read clock when reading
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM module (assumed externally provided)
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

endmodule


// Pointer synchronizer module: two-stage flip-flop synchronizer for Gray code pointer crossing clock domains
module ptr_sync #(
    parameter WIDTH = 5
)(
    input                  clk,
    input                  rst_n,
    input  [WIDTH-1:0]     async_ptr_in,
    output reg [WIDTH-1:0] sync_ptr_out
);

    reg [WIDTH-1:0] sync_ff1 = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= 0;
            sync_ptr_out <= 0;
        end else begin
            sync_ff1 <= async_ptr_in;
            sync_ptr_out <= sync_ff1;
        end
    end

endmodule