`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                 wclk,   // Write clock
    input  wire                 rclk,   // Read clock
    input  wire                 wrstn,  // Write domain async active-low reset
    input  wire                 rrstn,  // Read domain async active-low reset
    input  wire                 winc,   // Write increment enable
    input  wire                 rinc,   // Read increment enable
    input  wire [WIDTH-1:0]     wdata,  // Write data input
    output reg                  wfull,  // FIFO full flag (write side)
    output reg                  rempty, // FIFO empty flag (read side)
    output wire [WIDTH-1:0]     rdata   // Read data output
);

    // Local parameters for address and pointer width
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // Dual-port RAM submodule instantiation will be declared below

    //==========================================================================
    // Gray code conversion functions
    //==========================================================================
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH - 2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    //==========================================================================
    // Write pointer logic (binary and gray)
    //==========================================================================
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] wptr_bin_next;

    wire w_en = winc && !wfull; // Write enable gated by full flag

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            if (w_en) begin
                wptr_bin <= wptr_bin + 1'b1;
                wptr_gray <= bin2gray(wptr_bin + 1'b1);
            end
        end
    end

    //==========================================================================
    // Read pointer logic (binary and gray)
    //==========================================================================
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] rptr_bin_next;

    wire r_en = rinc && !rempty; // Read enable gated by empty flag

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            if (r_en) begin
                rptr_bin <= rptr_bin + 1'b1;
                rptr_gray <= bin2gray(rptr_bin + 1'b1);
            end
        end
    end

    //==========================================================================
    // Synchronize read pointer into write clock domain (two flop synchronizer)
    //==========================================================================
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= {PTR_WIDTH{1'b0}};
            rptr_gray_wclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    //==========================================================================
    // Synchronize write pointer into read clock domain (two flop synchronizer)
    //==========================================================================
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= {PTR_WIDTH{1'b0}};
            wptr_gray_rclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    //==========================================================================
    // Convert Gray pointers to binary for RAM addressing
    // Use lower ADDR_WIDTH bits of binary pointers as RAM addresses
    //==========================================================================
    wire [ADDR_WIDTH-1:0] waddr_ram = gray2bin(wptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = gray2bin(rptr_gray)[ADDR_WIDTH-1:0];

    //==========================================================================
    // Instantiate dual-port RAM
    //==========================================================================
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk  (wclk),
        .wenc  (w_en),
        .waddr (waddr_ram),
        .wdata (wdata),
        .rclk  (rclk),
        .renc  (r_en),
        .raddr (raddr_ram),
        .rdata (rdata)
    );

    //==========================================================================
    // Full flag logic
    // The FIFO is full when:
    // write pointer's MSBs = complement of read pointer's MSBs
    // and the remaining bits are equal
    //
    // For PTR_WIDTH bits: full condition is when
    // wptr_gray == {~rptr_gray_wclk_sync[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]}
    //==========================================================================
    wire full_condition = (wptr_gray == {~rptr_gray_wclk_sync[PTR_WIDTH-1], ~rptr_gray_wclk_sync[PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]});

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_condition;
    end

    //==========================================================================
    // Empty flag logic
    // FIFO is empty when read pointer equals synchronized write pointer
    //==========================================================================
    wire empty_condition = (rptr_gray == wptr_gray_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_condition;
    end

endmodule


//==============================================================================
// Dual-port RAM submodule for asynchronous FIFO storage
// Implements synchronous write and synchronous read using separate clocks.
// DEPTH and WIDTH are parameterized.
//==============================================================================
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                 wclk,
    input  wire                 wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]     wdata,
    input  wire                 rclk,
    input  wire                 renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]     rdata
);

    // RAM storage
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation (synchronous to wclk)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read operation (synchronous to rclk)
    // If renc is low, output retains last data (can be changed if needed)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule