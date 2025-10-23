`timescale 1ns/1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);
    // RAM memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write logic - synchronous with wclk
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read logic - synchronous with rclk
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // Hold last data if no read enable
    end

endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,
    input                  rrstn,
    input                  winc,
    input                  rinc,
    input  [WIDTH-1:0]     wdata,
    output                 wfull,
    output                 rempty,
    output [WIDTH-1:0]     rdata
);

    // Calculate pointer width: number of bits to address DEPTH locations
    localparam PTR_WIDTH = $clog2(DEPTH);
    // To use 4-bit Gray code for DEPTH=8 or 16
    // For DEPTH=16 PTR_WIDTH=4, Gray code width = PTR_WIDTH
    // For DEPTH=8 PTR_WIDTH=3, Gray code still 4 bits is required per spec for 8-depth FIFO 
    // But per description, always use PTR_WIDTH bits Gray code with DEPTH addressed bits as low bits.
    // We implement Gray code of PTR_WIDTH bits

    // Write pointer binary and gray
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] wptr;        // Gray code write pointer
    reg [PTR_WIDTH-1:0] wptr_buff1, wptr_buff2; // write pointer synchronizer to read clock domain

    // Read pointer binary and gray
    reg [PTR_WIDTH-1:0] raddr_bin;
    reg [PTR_WIDTH-1:0] rptr;        // Gray code read pointer
    reg [PTR_WIDTH-1:0] rptr_buff1, rptr_buff2; // read pointer synchronizer to write clock domain

    // Synchronized pointers for full/empty detection
    reg [PTR_WIDTH-1:0] rptr_syn; // read pointer synchronized to write clock domain
    reg [PTR_WIDTH-1:0] wptr_syn; // write pointer synchronized to read clock domain

    // Internal signals for RAM access
    wire w_en;
    wire r_en;

    // Binary to Gray code function
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray code to Binary function
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i -1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer increment on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= {PTR_WIDTH{1'b0}};
            wptr <= {PTR_WIDTH{1'b0}};
        end else begin
            if (winc && !wfull) begin
                waddr_bin <= waddr_bin + 1'b1;
            end
            wptr <= bin2gray(waddr_bin);
        end
    end

    // Read pointer increment on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= {PTR_WIDTH{1'b0}};
            rptr <= {PTR_WIDTH{1'b0}};
        end else begin
            if (rinc && !rempty) begin
                raddr_bin <= raddr_bin + 1'b1;
            end
            rptr <= bin2gray(raddr_bin);
        end
    end

    // Synchronize read pointer to write clock domain (2-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_buff1 <= 0;
            rptr_buff2 <= 0;
            rptr_syn <= 0;
        end else begin
            rptr_buff1 <= rptr;
            rptr_buff2 <= rptr_buff1;
            rptr_syn <= rptr_buff2;
        end
    end

    // Synchronize write pointer to read clock domain (2-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_buff1 <= 0;
            wptr_buff2 <= 0;
            wptr_syn <= 0;
        end else begin
            wptr_buff1 <= wptr;
            wptr_buff2 <= wptr_buff1;
            wptr_syn <= wptr_buff2;
        end
    end

    // Convert synchronized Gray pointers back to binary for comparison and RAM addressing
    wire [PTR_WIDTH-1:0] rbin_syn = gray2bin(rptr_syn);
    wire [PTR_WIDTH-1:0] wbin_syn = gray2bin(wptr_syn);

    // FIFO Full detection
    // "When the write pointer has one more cycle RAM than the read pointer,
    // the highest and second-highest bits of the read and write pointer are opposite,
    // the remaining bits are the same"
    // For depth 16 PTR_WIDTH=4, top two bits:
    // full = (wptr[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr[PTR_WIDTH-1:PTR_WIDTH-2]) && 
    //        (wptr[PTR_WIDTH-3:0] == rptr[PTR_WIDTH-3:0])
    // For general DEPTH, PTR_WIDTH variable
    // Note: If DEPTH<4, this logic may not hold, but DEPTH>=8 and 16 are expected
    wire full_condition;
    if (PTR_WIDTH >= 2) begin
        assign full_condition = 
            (wptr[PTR_WIDTH-1]     != rptr_syn[PTR_WIDTH-1]) &&
            (wptr[PTR_WIDTH-2]     != rptr_syn[PTR_WIDTH-2]) &&
            (wptr[PTR_WIDTH-3:0]  == rptr_syn[PTR_WIDTH-3:0]);
    end else begin
        // For very small DEPTH (PTR_WIDTH<2), full can't be properly detected as per given logic
        assign full_condition = 1'b0;
    end

    assign wfull = full_condition;

    // FIFO Empty detection: when read pointer equals write pointer
    assign rempty = (rptr == wptr_syn);

    // Write enable for RAM: enable only when write increment and not full
    assign w_en = winc & (~wfull);

    // Read enable for RAM: enable only when read increment and not empty
    assign r_en = rinc & (~rempty);

    // RAM addresses for write and read:
    // Use lower PTR_WIDTH-1 bits of binary address converted from Gray pointer as address
    // According to problem, use lower PTR_WIDTH-1 bits of binary pointer as RAM address
    // For DEPTH=16, PTR_WIDTH=4, lower 3 bits as address (0..7) does not cover all RAM
    // But problem states use the lower bits (e.g., 3 bits for DEPTH=8).
    // For general DEPTH, to cover entire RAM need all PTR_WIDTH bits, but problem defines
    // using lower PTR_WIDTH-1 bits only for RAM addressing.

    // To match problem statement exactly:
    // Use PTR_WIDTH=4 Gray code, convert to binary and use lower PTR_WIDTH-1 bits (3 bits) as address for DEPTH=8.
    // But since DEPTH is parameter, and addressing DEPTH locations requires $clog2(DEPTH) bits,
    // to strictly follow, for DEPTH=8 use 3 bits, for DEPTH=16 use 4 bits addressing.
    // So for general DEPTH:
    // RAM depth is 2**ADDR_WIDTH
    // We choose to use full PTR_WIDTH bits for address except for DEPTH=8 (special case) where 4-bit gray code and 3-bit address are used.
    // To implement exactly as problem states:
    // If DEPTH==8, use lower 3 bits of binary pointer as address.
    // Otherwise, use all PTR_WIDTH bits.

    wire [$clog2(DEPTH)-1:0] waddr = (DEPTH == 8) ? wbin_syn[2:0] : wbin_syn;
    wire [$clog2(DEPTH)-1:0] raddr = (DEPTH == 8) ? raddr_bin[2:0] : raddr_bin;

    // Instantiate the dual port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk (wclk),
        .wenc (w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk (rclk),
        .renc (r_en),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule