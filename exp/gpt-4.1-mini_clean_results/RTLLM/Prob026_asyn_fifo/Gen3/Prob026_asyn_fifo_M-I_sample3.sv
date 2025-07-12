`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                 wclk,
    input  wire                 wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,

    input  wire                 rclk,
    input  wire                 renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
);

    // Memory array declaration
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


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

    // Local parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;  // One extra bit for full detection

    // Gray code conversion functions
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // Write pointer binary and Gray code
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Read pointer binary and Gray code
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronizers for pointers crossing clock domains
    // Synchronize read pointer into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;

    // Synchronize write pointer into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;

    // Write enable and read enable signals gated by full/empty flags
    wire wen = winc & ~wfull;
    wire ren = rinc & ~rempty;

    // Write pointer logic with asynchronous reset
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (wen) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer logic with asynchronous reset
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (ren) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Two-stage synchronizer for read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Two-stage synchronizer for write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Convert Gray code pointers to binary for addressing
    wire [PTR_WIDTH-1:0] rptr_bin_sync = gray2bin(rptr_gray_sync2);
    wire [PTR_WIDTH-1:0] wptr_bin_sync = gray2bin(wptr_gray_sync2);

    // RAM write and read addresses: lower ADDR_WIDTH bits of pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate the dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Full condition detection (write clock domain):
    // FIFO is full when the write pointer is exactly one cycle ahead of the read pointer,
    // as specified by the condition:
    // The highest two bits of the write pointer are the inverse of those of the read pointer,
    // and the remaining bits are equal.
    // Using Gray code pointers, full condition:
    // wptr_gray[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2]
    // and wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync2[PTR_WIDTH-3:0]
    wire full_condition = 
        (wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_sync2[PTR_WIDTH-1]) &&
        (wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_sync2[PTR_WIDTH-2]) &&
        (wptr_gray[PTR_WIDTH-3:0] ==  rptr_gray_sync2[PTR_WIDTH-3:0]);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_condition;
    end

    // Empty condition detection (read clock domain):
    // FIFO is empty when the read pointer equals the synchronized write pointer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= (rptr_gray == wptr_gray_sync2);
    end

endmodule