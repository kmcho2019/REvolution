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
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1; // Extra bit for full detection

    // Binary and Gray pointer registers
    reg [PTR_EXT-1:0] wptr_bin;
    reg [PTR_EXT-1:0] rptr_bin;
    reg [PTR_EXT-1:0] wptr_gray;
    reg [PTR_EXT-1:0] rptr_gray;

    // Synchronizers for pointers crossing clock domains
    wire [PTR_EXT-1:0] rptr_gray_sync_w;
    wire [PTR_EXT-1:0] wptr_gray_sync_r;

    // Write enable and read enable signals with full/empty gating
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Functions for Gray code conversions
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_EXT-1] = bin[PTR_EXT-1];
            for (i=PTR_EXT-2; i>=0; i=i-1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for(i=PTR_EXT-2; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer binary and Gray code update (on wclk domain)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer binary and Gray code update (on rclk domain)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronizers (2-stage registers) for read pointer into write clock domain
    pointer_sync #(.WIDTH(PTR_EXT)) rptr_sync_inst (
        .clk(wclk),
        .rstn(wrstn),
        .data_in(rptr_gray),
        .data_out(rptr_gray_sync_w)
    );

    // Synchronizers (2-stage registers) for write pointer into read clock domain
    pointer_sync #(.WIDTH(PTR_EXT)) wptr_sync_inst (
        .clk(rclk),
        .rstn(rrstn),
        .data_in(wptr_gray),
        .data_out(wptr_gray_sync_r)
    );

    // RAM addresses derived from binary pointers (lower PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // FIFO Full Condition:
    // When the next write pointer equals read pointer with MSB and MSB-1 inverted and rest equal
    wire full_cond = (bin2gray(wptr_bin + 1'b1)[PTR_EXT-3:0] == rptr_gray_sync_w[PTR_EXT-3:0]) &&
                     (bin2gray(wptr_bin + 1'b1)[PTR_EXT-1] != rptr_gray_sync_w[PTR_EXT-1]) &&
                     (bin2gray(wptr_bin + 1'b1)[PTR_EXT-2] != rptr_gray_sync_w[PTR_EXT-2]);

    assign wfull = full_cond;

    // FIFO Empty Condition:
    // When the read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_r);

    // Register read data on rclk when read enable asserted
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate the dual-port RAM with distinct name to avoid conflicts
    dp_ram #(
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


// 2-stage synchronizer module for pointer crossing clock domains
module pointer_sync #(
    parameter WIDTH = 5
)(
    input                  clk,
    input                  rstn,
    input      [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] sync_0;
    reg [WIDTH-1:0] sync_1;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            sync_0 <= 0;
            sync_1 <= 0;
            data_out <= 0;
        end else begin
            sync_0 <= data_in;
            sync_1 <= sync_0;
            data_out <= sync_1;
        end
    end
endmodule


// Dual-port RAM module with separate clocks and synchronous write/read
module dp_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                         wclk,
    input                         wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]        wdata,
    input                         rclk,
    input                         renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]        rdata
);
    // RAM storage
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule