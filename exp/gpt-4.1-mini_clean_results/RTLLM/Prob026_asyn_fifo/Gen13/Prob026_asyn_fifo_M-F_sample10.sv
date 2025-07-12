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
    localparam PTR_EXT = PTR_WIDTH + 1;

    // Write pointer binary and Gray
    reg [PTR_EXT-1:0] wptr_bin;
    reg [PTR_EXT-1:0] wptr_gray;

    // Read pointer binary and Gray
    reg [PTR_EXT-1:0] rptr_bin;
    reg [PTR_EXT-1:0] rptr_gray;

    // Synchronize read pointer Gray into write clock domain (2-stage)
    reg [PTR_EXT-1:0] rptr_gray_w1, rptr_gray_w2;
    wire [PTR_EXT-1:0] rptr_gray_sync = rptr_gray_w2;

    // Synchronize write pointer Gray into read clock domain (2-stage)
    reg [PTR_EXT-1:0] wptr_gray_r1, wptr_gray_r2;
    wire [PTR_EXT-1:0] wptr_gray_sync = wptr_gray_r2;

    // Write enable and read enable gated by full/empty
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Gray code conversion (binary to gray)
    function [PTR_EXT-1:0] bin2gray;
        input [PTR_EXT-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Gray to binary conversion
    function [PTR_EXT-1:0] gray2bin;
        input [PTR_EXT-1:0] gray;
        integer i;
        reg [PTR_EXT-1:0] bin;
        begin
            bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for (i = PTR_EXT - 2; i >= 0; i = i - 1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // Write pointer increment & gray update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer increment & gray update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_w1 <= 0;
            rptr_gray_w2 <= 0;
        end else begin
            rptr_gray_w1 <= rptr_gray;
            rptr_gray_w2 <= rptr_gray_w1;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_r1 <= 0;
            wptr_gray_r2 <= 0;
        end else begin
            wptr_gray_r1 <= wptr_gray;
            wptr_gray_r2 <= wptr_gray_r1;
        end
    end

    // Convert synchronized Gray pointers to binary for comparison/addressing
    wire [PTR_EXT-1:0] rptr_bin_sync = gray2bin(rptr_gray_sync);
    wire [PTR_EXT-1:0] wptr_bin_sync = gray2bin(wptr_gray_sync);

    // Write and read addresses for RAM use lower PTR_WIDTH bits
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Full condition:
    // When write pointer equals read pointer with top two bits inverted
    wire full_cond = (wptr_gray == {~rptr_gray_sync[PTR_EXT-1:PTR_EXT-2], rptr_gray_sync[PTR_EXT-3:0]});
    assign wfull = full_cond;

    // Empty condition: pointers equal
    assign rempty = (rptr_gray == wptr_gray_sync);

    // Register read data on rclk when r_en
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate renamed dual-port RAM
    async_fifo_dual_port_RAM #(
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


module async_fifo_dual_port_RAM #(
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