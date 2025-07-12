`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,
    input                 rrstn,
    input                 winc,
    input                 rinc,
    input  [WIDTH-1:0]    wdata,
    output                wfull,
    output                rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1; // extended pointer width with extra bit

    // Binary pointers
    reg [PTR_EXT-1:0] wptr_bin, rptr_bin;
    // Gray pointers
    reg [PTR_EXT-1:0] wptr_gray, rptr_gray;

    // Synchronized pointers crossing clock domains
    reg [PTR_EXT-1:0] rptr_gray_sync_w1, rptr_gray_sync_w2;
    reg [PTR_EXT-1:0] wptr_gray_sync_r1, wptr_gray_sync_r2;

    // Write enable and read enable gated by full/empty
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Binary to Gray code conversion
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to Binary conversion
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for(i=PTR_EXT-2; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer update (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
        end
    end

    // Read pointer update (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
        end
    end

    // Synchronize read pointer to write clock domain (2-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_w1 <= 0;
            rptr_gray_sync_w2 <= 0;
        end else begin
            rptr_gray_sync_w1 <= rptr_gray;
            rptr_gray_sync_w2 <= rptr_gray_sync_w1;
        end
    end

    // Synchronize write pointer to read clock domain (2-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_r1 <= 0;
            wptr_gray_sync_r2 <= 0;
        end else begin
            wptr_gray_sync_r1 <= wptr_gray;
            wptr_gray_sync_r2 <= wptr_gray_sync_r1;
        end
    end

    // RAM addresses from lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Full detection:
    // FIFO is full when:
    // next write pointer's Gray code equals read pointer Gray code with MSB and next MSB inverted and rest equal
    wire [PTR_EXT-1:0] wptr_gray_next = bin2gray(wptr_bin + 1);
    wire full_flag = (wptr_gray_next[PTR_EXT-3:0] == rptr_gray_sync_w2[PTR_EXT-3:0]) &&
                     (wptr_gray_next[PTR_EXT-1] != rptr_gray_sync_w2[PTR_EXT-1]) &&
                     (wptr_gray_next[PTR_EXT-2] != rptr_gray_sync_w2[PTR_EXT-2]);
    assign wfull = full_flag;

    // Empty detection: FIFO empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_r2);

    // Read data registered on read clock when r_en
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM module (assumed pre-defined elsewhere)
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