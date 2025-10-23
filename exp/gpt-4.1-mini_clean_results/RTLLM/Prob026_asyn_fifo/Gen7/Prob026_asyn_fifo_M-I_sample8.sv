`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // Active low reset for write domain
    input                   rrstn,      // Active low reset for read domain
    input                   winc,       // Write increment signal (write enable)
    input                   rinc,       // Read increment signal (read enable)
    input       [WIDTH-1:0] wdata,
    output                  wfull,      // FIFO full flag in write domain
    output                  rempty,     // FIFO empty flag in read domain
    output reg  [WIDTH-1:0] rdata       // Data output from FIFO (read domain)
);

    // Calculate pointer width: add 1 bit for distinguishing full/empty wrap-around
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1;  // Extra MSB for wrap-around detection

    // Binary pointers (write and read)
    reg [PTR_EXT_WIDTH-1:0] wptr_bin;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin;

    // Gray-coded pointers (write and read)
    reg [PTR_EXT_WIDTH-1:0] wptr_gray;
    reg [PTR_EXT_WIDTH-1:0] rptr_gray;

    // Synchronized pointers crossing clock domains
    reg [PTR_EXT_WIDTH-1:0] rptr_gray_wclk_1, rptr_gray_wclk_2;
    reg [PTR_EXT_WIDTH-1:0] wptr_gray_rclk_1, wptr_gray_rclk_2;

    // Write enable gated by not full
    wire w_en = winc & ~wfull;
    // Read enable gated by not empty
    wire r_en = rinc & ~rempty;

    // RAM addresses are lower PTR_WIDTH bits of the binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Binary to Gray code conversion function
    function [PTR_EXT_WIDTH-1:0] bin2gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for(i = PTR_EXT_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray code to Binary conversion function
    function [PTR_EXT_WIDTH-1:0] gray2bin;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for(j = PTR_EXT_WIDTH-2; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

    // Write pointer logic (binary + gray), synchronous reset
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= {PTR_EXT_WIDTH{1'b0}};
            wptr_gray <= {PTR_EXT_WIDTH{1'b0}};
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer logic (binary + gray), synchronous reset
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= {PTR_EXT_WIDTH{1'b0}};
            rptr_gray <= {PTR_EXT_WIDTH{1'b0}};
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer Gray code into write clock domain (2-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_1 <= {PTR_EXT_WIDTH{1'b0}};
            rptr_gray_wclk_2 <= {PTR_EXT_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_1 <= rptr_gray;
            rptr_gray_wclk_2 <= rptr_gray_wclk_1;
        end
    end

    // Synchronize write pointer Gray code into read clock domain (2-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_1 <= {PTR_EXT_WIDTH{1'b0}};
            wptr_gray_rclk_2 <= {PTR_EXT_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_1 <= wptr_gray;
            wptr_gray_rclk_2 <= wptr_gray_rclk_1;
        end
    end

    // Full detection:
    // FIFO is full when next write pointer (gray) equals read pointer with MSB and next MSB inverted, and rest equal
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin + 1'b1);

    assign wfull = ((wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_wclk_2[PTR_EXT_WIDTH-3:0]) &&
                    (wptr_gray_next[PTR_EXT_WIDTH-1] != rptr_gray_wclk_2[PTR_EXT_WIDTH-1]) &&
                    (wptr_gray_next[PTR_EXT_WIDTH-2] != rptr_gray_wclk_2[PTR_EXT_WIDTH-2]));

    // Empty detection:
    // FIFO is empty when read pointer equals synchronized write pointer (both Gray-coded)
    assign rempty = (rptr_gray == wptr_gray_rclk_2);

    // Register read data output, update on read enable and clock
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

    // Instantiate the dual-port RAM submodule
    // It is assumed that this module is defined elsewhere in the environment,
    // matching the specified interface:
    //   input wclk, input wenc, input [ADDR_WIDTH-1:0] waddr, input [WIDTH-1:0] wdata,
    //   input rclk, input renc, input [ADDR_WIDTH-1:0] raddr, output reg [WIDTH-1:0] rdata;
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