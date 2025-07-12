`timescale 1ns / 1ps

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

    // Local parameters
    localparam PTR_WIDTH = $clog2(DEPTH);        // Number of address bits
    localparam FIFO_PTR_WIDTH = PTR_WIDTH + 1;   // Pointer width including MSB for full detection

    // Internal signals
    
    // Binary write pointer and its Gray code
    reg [FIFO_PTR_WIDTH-1:0] wptr_bin;
    reg [FIFO_PTR_WIDTH-1:0] wptr_gray;

    // Binary read pointer and its Gray code
    reg [FIFO_PTR_WIDTH-1:0] rptr_bin;
    reg [FIFO_PTR_WIDTH-1:0] rptr_gray;

    // Synchronizers for pointers crossing clock domains
    reg [FIFO_PTR_WIDTH-1:0] rptr_gray_wclk_ff1, rptr_gray_wclk_ff2;
    reg [FIFO_PTR_WIDTH-1:0] wptr_gray_rclk_ff1, wptr_gray_rclk_ff2;

    // RAM addresses for write and read (lower PTR_WIDTH bits of the binary pointers)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // RAM enable signals
    wire wwrite_en = winc & (~wfull);
    wire rread_en  = rinc & (~rempty);

    // Function: binary to Gray code conversion
    function [FIFO_PTR_WIDTH-1:0] bin2gray;
        input [FIFO_PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[FIFO_PTR_WIDTH-1] = bin[FIFO_PTR_WIDTH-1];
            for (i = FIFO_PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Function: Gray code to binary conversion
    function [FIFO_PTR_WIDTH-1:0] gray2bin;
        input [FIFO_PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[FIFO_PTR_WIDTH-1] = gray[FIFO_PTR_WIDTH-1];
            for (i = FIFO_PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    //---------------------------------------------------
    // Write pointer logic (wclk domain)
    //---------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (winc & ~wfull) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    //---------------------------------------------------
    // Read pointer logic (rclk domain)
    //---------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (rinc & ~rempty) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    //---------------------------------------------------
    // Synchronize read pointer to write clock domain
    //---------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_ff1 <= 0;
            rptr_gray_wclk_ff2 <= 0;
        end else begin
            rptr_gray_wclk_ff1 <= rptr_gray;
            rptr_gray_wclk_ff2 <= rptr_gray_wclk_ff1;
        end
    end

    //---------------------------------------------------
    // Synchronize write pointer to read clock domain
    //---------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_ff1 <= 0;
            wptr_gray_rclk_ff2 <= 0;
        end else begin
            wptr_gray_rclk_ff1 <= wptr_gray;
            wptr_gray_rclk_ff2 <= wptr_gray_rclk_ff1;
        end
    end

    //---------------------------------------------------
    // Convert synchronized pointers back to binary
    //---------------------------------------------------
    wire [FIFO_PTR_WIDTH-1:0] rptr_sync_wclk_bin = gray2bin(rptr_gray_wclk_ff2);
    wire [FIFO_PTR_WIDTH-1:0] wptr_sync_rclk_bin = gray2bin(wptr_gray_rclk_ff2);

    //---------------------------------------------------
    // FIFO full detection logic (write clock domain)
    //---------------------------------------------------
    // Next write pointer binary
    wire [FIFO_PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [FIFO_PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // FIFO full condition when:
    // wptr_gray_next[MSB:MSB-1] == inverted of rptr_gray_wclk_ff2[MSB:MSB-1]
    // and lower bits equal
    wire full_cond_lower_bits_equal = (wptr_gray_next[FIFO_PTR_WIDTH-2:0] == rptr_gray_wclk_ff2[FIFO_PTR_WIDTH-2:0]);
    wire full_cond_msb_inverted     = (wptr_gray_next[FIFO_PTR_WIDTH-1]   != rptr_gray_wclk_ff2[FIFO_PTR_WIDTH-1]);
    wire full_cond_next_msb_inverted= (wptr_gray_next[FIFO_PTR_WIDTH-2]   != rptr_gray_wclk_ff2[FIFO_PTR_WIDTH-2]);

    assign wfull = full_cond_lower_bits_equal && full_cond_msb_inverted && full_cond_next_msb_inverted;

    //---------------------------------------------------
    // FIFO empty detection logic (read clock domain)
    //---------------------------------------------------
    assign rempty = (rptr_gray == wptr_gray_rclk_ff2);

    //---------------------------------------------------
    // Dual-port RAM instantiation
    //---------------------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk  (wclk),
        .wenc  (wwrite_en),
        .waddr (waddr),
        .wdata (wdata),
        .rclk  (rclk),
        .renc  (rread_en),
        .raddr (raddr),
        .rdata (rdata)
    );

endmodule


// Dual-port RAM module
module dual_port_RAM #(
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

    // Memory array declaration
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port: synchronous write on wclk
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port: synchronous read on rclk
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule