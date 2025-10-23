`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input  wire                  wclk,
    input  wire                  wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,
    input  wire                  rclk,
    input  wire                  renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
);
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // Hold previous value
    end
endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,
    input  wire                 rrstn,
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output reg                  wfull,
    output reg                  rempty,
    output wire [WIDTH-1:0]     rdata
);

    // Gray code conversion functions
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) 
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer binary and Gray code
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Read pointer binary and Gray code
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronize read pointer into write clock domain (two stage)
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;

    // Synchronize write pointer into read clock domain (two stage)
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    // Write and read enable signals gated by full/empty
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Increment write pointer on wclk
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin  <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
        end
    end

    // Increment read pointer on rclk
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin  <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
        end
    end

    // Synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Convert Gray code pointers to binary for RAM addressing
    wire [ADDR_WIDTH-1:0] waddr = gray2bin(wptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = gray2bin(rptr_bin)[ADDR_WIDTH-1:0];

    // Instantiate the dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(gray2bin(rptr_gray)[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // Full condition:
    // When write pointer equals read pointer with MSBs inverted (for DEPTH=16, PTR_WIDTH=5):
    // full when wptr_gray == {~rptr_gray_wclk_sync[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]}
    wire full_cond = (wptr_gray == {~rptr_gray_wclk_sync[PTR_WIDTH-1], ~rptr_gray_wclk_sync[PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]});

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_cond;
    end

    // Empty condition: read and write pointers are equal
    wire empty_cond = (rptr_gray == wptr_gray_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_cond;
    end

endmodule