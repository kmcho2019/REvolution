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

    // Calculate pointer widths
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam GREY_WIDTH = PTR_WIDTH + 1;

    // Binary and Gray write pointer (write clock domain)
    reg [PTR_WIDTH:0] wptr_bin;
    reg [GREY_WIDTH-1:0] wptr_gray;

    // Binary and Gray read pointer (read clock domain)
    reg [PTR_WIDTH:0] rptr_bin;
    reg [GREY_WIDTH-1:0] rptr_gray;

    // Synchronize remote pointers with two flip-flops
    reg [GREY_WIDTH-1:0] rptr_gray_sync_wclk1, rptr_gray_sync_wclk2;
    reg [GREY_WIDTH-1:0] wptr_gray_sync_rclk1, wptr_gray_sync_rclk2;

    // Write enable gated with not full
    wire w_en = winc & ~wfull;
    // Read enable gated with not empty
    wire r_en = rinc & ~rempty;

    // Binary to Gray conversion function
    function [GREY_WIDTH-1:0] bin2gray(input [PTR_WIDTH:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Gray to Binary conversion function
    function [PTR_WIDTH:0] gray2bin(input [GREY_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH:0] bin;
        begin
            bin[PTR_WIDTH] = gray[GREY_WIDTH-1];
            for (i = PTR_WIDTH-1; i >= 0; i = i -1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // Write pointer increment (wclk domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer increment (rclk domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk1 <= 0;
            rptr_gray_sync_wclk2 <= 0;
        end else begin
            rptr_gray_sync_wclk1 <= rptr_gray;
            rptr_gray_sync_wclk2 <= rptr_gray_sync_wclk1;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk1 <= 0;
            wptr_gray_sync_rclk2 <= 0;
        end else begin
            wptr_gray_sync_rclk1 <= wptr_gray;
            wptr_gray_sync_rclk2 <= wptr_gray_sync_rclk1;
        end
    end

    // Convert synchronized pointers back to binary
    wire [PTR_WIDTH:0] rptr_bin_sync = gray2bin(rptr_gray_sync_wclk2);
    wire [PTR_WIDTH:0] wptr_bin_sync = gray2bin(wptr_gray_sync_rclk2);

    // RAM addresses: lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Calculate next write pointer gray code for full detection
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [GREY_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // Full flag detection:
    // Full when next write pointer equals read pointer with top two bits inverted
    assign wfull = (wptr_gray_next[GREY_WIDTH-3:0] == rptr_gray_sync_wclk2[GREY_WIDTH-3:0]) &&
                   (wptr_gray_next[GREY_WIDTH-1] != rptr_gray_sync_wclk2[GREY_WIDTH-1]) &&
                   (wptr_gray_next[GREY_WIDTH-2] != rptr_gray_sync_wclk2[GREY_WIDTH-2]);

    // Empty flag detection: when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_rclk2);

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    // Register read data on read clock when reading
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM
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

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]      wdata,
    input                       rclk,
    input                       renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule