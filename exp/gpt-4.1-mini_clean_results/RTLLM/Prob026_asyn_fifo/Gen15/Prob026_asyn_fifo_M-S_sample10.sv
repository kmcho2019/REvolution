`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                wclk,    // Write clock
    input                rclk,    // Read clock
    input                wrstn,   // Write reset, active low
    input                rrstn,   // Read reset, active low
    input                winc,    // Write increment
    input                rinc,    // Read increment
    input  [WIDTH-1:0]   wdata,   // Write data
    output               wfull,   // FIFO full
    output               rempty,  // FIFO empty
    output reg [WIDTH-1:0] rdata  // Read data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // extra bit for full/empty distinction

    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to Binary conversion
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin_tmp;
        begin
            bin_tmp[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
            gray2bin = bin_tmp;
        end
    endfunction

    // Write pointer (binary and gray)
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;

    wire w_en = winc & ~wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer (binary and gray)
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;

    wire r_en = rinc & ~rempty;

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
    reg [PTR_WIDTH-1:0] rptr_gray_w_sync1 = 0, rptr_gray_w_sync2 = 0;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_w_sync1 <= 0;
            rptr_gray_w_sync2 <= 0;
        end else begin
            rptr_gray_w_sync1 <= rptr_gray;
            rptr_gray_w_sync2 <= rptr_gray_w_sync1;
        end
    end
    wire [PTR_WIDTH-1:0] rptr_gray_w = rptr_gray_w_sync2;

    // Synchronize write pointer into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_r_sync1 = 0, wptr_gray_r_sync2 = 0;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_r_sync1 <= 0;
            wptr_gray_r_sync2 <= 0;
        end else begin
            wptr_gray_r_sync1 <= wptr_gray;
            wptr_gray_r_sync2 <= wptr_gray_r_sync1;
        end
    end
    wire [PTR_WIDTH-1:0] wptr_gray_r = wptr_gray_r_sync2;

    // Full detection:
    // FIFO full when write pointer equals read pointer with MSBs inverted
    assign wfull = (wptr_gray == {~rptr_gray_w[PTR_WIDTH-1], ~rptr_gray_w[PTR_WIDTH-2], rptr_gray_w[PTR_WIDTH-3:0]});

    // Empty detection:
    // FIFO empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_r);

    // RAM addresses come from pointer binary lower bits
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire ram_wen = w_en;
    wire ram_ren = r_en;

    wire [WIDTH-1:0] ram_rdata;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(ram_wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ram_ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Register read data on read clock when reading and not empty
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

endmodule


// Simple dual-port RAM module
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                     wclk,
    input                     wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]    wdata,
    input                     rclk,
    input                     renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]    rdata
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