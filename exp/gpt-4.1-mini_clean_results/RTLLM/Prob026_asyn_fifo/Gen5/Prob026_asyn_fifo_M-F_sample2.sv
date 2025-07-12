`timescale 1ns / 1ps

module dp_ram_async #(
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

    // Memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // hold previous value when no read
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
    input  wire                 wrstn,    // active low reset for write domain
    input  wire                 rrstn,    // active low reset for read domain
    input  wire                 winc,     // write increment request
    input  wire                 rinc,     // read increment request
    input  wire [WIDTH-1:0]     wdata,    // data input for write
    output reg                  wfull,    // FIFO full flag
    output reg                  rempty,   // FIFO empty flag
    output wire [WIDTH-1:0]     rdata     // data output for read
);

    // Convert binary to Gray code
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Convert Gray code to binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    // Write pointer (binary and gray)
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Read pointer (binary and gray)
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronize read pointer into write clock domain (two-stage registers)
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta;
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync;

    // Synchronize write pointer into read clock domain (two-stage registers)
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta;
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync;

    // Write enable gated by full flag
    wire wen = winc & ~wfull;

    // Read enable gated by empty flag
    wire ren = rinc & ~rempty;

    // Write pointer update (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (wen) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer update (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (ren) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= {PTR_WIDTH{1'b0}};
            rptr_gray_wclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= {PTR_WIDTH{1'b0}};
            wptr_gray_rclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Convert Gray code pointers to binary for RAM addressing
    wire [ADDR_WIDTH-1:0] waddr = gray2bin(wptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = gray2bin(rptr_gray)[ADDR_WIDTH-1:0];

    // RAM read address from read pointer (synchronous with rclk)
    // raddr always valid from current rptr_gray

    // Instantiate dual-port RAM
    dp_ram_async #(
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
        .raddr(raddr),
        .rdata(rdata)
    );

    // Full condition (write clock domain)
    // FIFO is full when write pointer is one cycle ahead of read pointer with MSB and MSB-1 inverted
    wire full_flag = (wptr_gray == {~rptr_gray_wclk_sync[PTR_WIDTH-1], ~rptr_gray_wclk_sync[PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]});

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_flag;
    end

    // Empty condition (read clock domain)
    // FIFO is empty when read pointer equals synchronized write pointer
    wire empty_flag = (rptr_gray == wptr_gray_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_flag;
    end

endmodule