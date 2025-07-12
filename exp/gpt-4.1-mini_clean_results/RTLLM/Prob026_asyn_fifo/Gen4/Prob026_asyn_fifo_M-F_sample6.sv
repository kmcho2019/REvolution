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
            rdata <= rdata; // Hold previous data when no read enable
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
    input  wire                 winc,     // write increment (write request)
    input  wire                 rinc,     // read increment (read request)
    input  wire [WIDTH-1:0]     wdata,    // data input for write
    output reg                  wfull,    // write full indicator
    output reg                  rempty,   // read empty indicator
    output wire [WIDTH-1:0]     rdata     // data output for read
);

    // Function: binary to Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Function: Gray code to binary conversion
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i -1) begin
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

    // Synchronizers for crossing clock domains:
    // Read pointer synchronized into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;

    // Write pointer synchronized into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    // Increment enables gated by full and empty flags
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Write pointer update in write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin  <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
        end
    end

    // Read pointer update in read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin  <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
        end
    end

    // Synchronize read pointer into write clock domain (two stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain (two stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Convert Gray pointers to binary for addressing RAM
    wire [ADDR_WIDTH-1:0] waddr = gray2bin(wptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = gray2bin(rptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_sync = gray2bin(rptr_gray_wclk_sync)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] waddr_sync = gray2bin(wptr_gray_rclk_sync)[ADDR_WIDTH-1:0];

    // Instantiate dual port RAM
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
        .raddr(raddr),
        .rdata(rdata)
    );

    // Full condition check in write clock domain:
    // Full when the write pointer equals read pointer with MSB and MSB-1 bits inverted
    // {~rptr_gray_wclk_sync[PTR_WIDTH-1], ~rptr_gray_wclk_sync[PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]}
    wire full_flag = (wptr_gray == {~rptr_gray_wclk_sync[PTR_WIDTH-1], ~rptr_gray_wclk_sync[PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]});

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_flag;
    end

    // Empty condition check in read clock domain:
    // Empty when read pointer equals write pointer synchronized into read clock domain
    wire empty_flag = (rptr_gray == wptr_gray_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_flag;
    end

endmodule