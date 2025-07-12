`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,   // active low write domain reset
    input                  rrstn,   // active low read domain reset
    input                  winc,
    input                  rinc,
    input  [WIDTH-1:0]     wdata,
    output                 wfull,
    output                 rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1;

    // Binary to Gray conversion
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to binary conversion
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin;
        begin
            bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for (i = PTR_EXT-2; i >= 0; i = i - 1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // Write pointer logic
    reg [PTR_EXT-1:0] wptr_bin = 0;
    reg [PTR_EXT-1:0] wptr_gray = 0;
    wire w_en = winc && !wfull;
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + (w_en ? 1'b1 : 1'b0);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // Read pointer logic
    reg [PTR_EXT-1:0] rptr_bin = 0;
    reg [PTR_EXT-1:0] rptr_gray = 0;
    wire r_en = rinc && !rempty;
    wire [PTR_EXT-1:0] rptr_bin_next = rptr_bin + (r_en ? 1'b1 : 1'b0);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // Synchronize read pointer into write clock domain (2-stage)
    reg [PTR_EXT-1:0] rptr_gray_wclk_1 = 0, rptr_gray_wclk_2 = 0;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_1 <= 0;
            rptr_gray_wclk_2 <= 0;
        end else begin
            rptr_gray_wclk_1 <= rptr_gray;
            rptr_gray_wclk_2 <= rptr_gray_wclk_1;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage)
    reg [PTR_EXT-1:0] wptr_gray_rclk_1 = 0, wptr_gray_rclk_2 = 0;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_1 <= 0;
            wptr_gray_rclk_2 <= 0;
        end else begin
            wptr_gray_rclk_1 <= wptr_gray;
            wptr_gray_rclk_2 <= wptr_gray_rclk_1;
        end
    end

    // Convert synchronized Gray pointers back to binary for address usage
    wire [PTR_EXT-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk_2);
    wire [PTR_EXT-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk_2);

    // Addresses for RAM (lower bits)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Full: write pointer equals read pointer with top two bits inverted and rest same
    assign wfull = (wptr_gray == {~rptr_gray_wclk_2[PTR_EXT-1:PTR_EXT-2], rptr_gray_wclk_2[PTR_EXT-3:0]});

    // Empty: read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_2);

    // RAM read data
    wire [WIDTH-1:0] ram_rdata;

    // Register read data at read clock when reading and FIFO not empty
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
    ) ram (
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


// Dual-port RAM submodule as specified
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