`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    // Binary pointers with extra bit for full/empty detection
    reg [PTR_WIDTH:0] wbin = 0, rbin = 0;
    reg [PTR_WIDTH:0] wgray = 0, rgray = 0;

    // Synchronized pointers in opposite clock domains
    reg [PTR_WIDTH:0] rgray_wclk_1 = 0, rgray_wclk_2 = 0; // read ptr synchronized into wclk domain
    reg [PTR_WIDTH:0] wgray_rclk_1 = 0, wgray_rclk_2 = 0; // write ptr synchronized into rclk domain

    // Write enable gated by full
    wire w_en = winc & ~wfull;
    // Read enable gated by empty
    wire r_en = rinc & ~rempty;

    // Write and read addresses derived from binary pointers
    wire [PTR_WIDTH-1:0] waddr = wbin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rbin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Binary to Gray code conversion
    function [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray code to binary conversion
    function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i -1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer logic in write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wbin <= 0;
            wgray <= 0;
        end else if (w_en) begin
            wbin <= wbin + 1'b1;
            wgray <= bin2gray(wbin + 1'b1);
        end
    end

    // Read pointer logic in read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rbin <= 0;
            rgray <= 0;
        end else if (r_en) begin
            rbin <= rbin + 1'b1;
            rgray <= bin2gray(rbin + 1'b1);
        end
    end

    // Two-stage synchronizers: read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rgray_wclk_1 <= 0;
            rgray_wclk_2 <= 0;
        end else begin
            rgray_wclk_1 <= rgray;
            rgray_wclk_2 <= rgray_wclk_1;
        end
    end

    // Two-stage synchronizers: write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wgray_rclk_1 <= 0;
            wgray_rclk_2 <= 0;
        end else begin
            wgray_rclk_1 <= wgray;
            wgray_rclk_2 <= wgray_rclk_1;
        end
    end

    // Full detection:
    // FIFO full if next write pointer equals read pointer with two MSB bits inverted
    wire [PTR_WIDTH:0] wbin_next = wbin + 1'b1;
    wire [PTR_WIDTH:0] wgray_next = bin2gray(wbin_next);

    wire wfull_w;
    assign wfull_w =
        (wgray_next[PTR_WIDTH-1:0] == rgray_wclk_2[PTR_WIDTH-1:0]) &&
        (wgray_next[PTR_WIDTH] != rgray_wclk_2[PTR_WIDTH]) &&
        (wgray_next[PTR_WIDTH-1] != rgray_wclk_2[PTR_WIDTH-1]);

    assign wfull = wfull_w;

    // Empty detection:
    // FIFO empty if read pointer equals synchronized write pointer
    wire rempty_r = (rgray == wgray_rclk_2);
    assign rempty = rempty_r;

    // Register read data when read enabled
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
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


// Dual-port RAM with independent clocks and enables
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