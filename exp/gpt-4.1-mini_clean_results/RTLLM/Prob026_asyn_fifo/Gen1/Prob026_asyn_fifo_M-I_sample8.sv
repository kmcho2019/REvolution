`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,    // Write clock
    input                    rclk,    // Read clock
    input                    wrstn,   // Write domain reset (active low)
    input                    rrstn,   // Read domain reset (active low)
    input                    winc,    // Write increment (push)
    input                    rinc,    // Read increment (pop)
    input      [WIDTH-1:0]   wdata,   // Write data input
    output                   wfull,   // FIFO full indicator
    output                   rempty,  // FIFO empty indicator
    output reg [WIDTH-1:0]   rdata    // Read data output
);

    // Number of address bits needed for DEPTH locations
    localparam PTR_WIDTH = $clog2(DEPTH);
    // Gray code width (one bit wider than binary pointer for full detection)
    localparam GRAY_WIDTH = PTR_WIDTH + 1;

    // ---------------------------
    // Internal signals declaration
    // ---------------------------

    // Binary pointers (write & read), one bit wider than address for wrap detection
    reg [PTR_WIDTH:0] wptr_bin;
    reg [PTR_WIDTH:0] rptr_bin;

    // Gray code pointers (write & read)
    reg [GRAY_WIDTH-1:0] wptr_gray;
    reg [GRAY_WIDTH-1:0] rptr_gray;

    // Pointer synchronizers: 
    // Synchronize read pointer into write clock domain (2 FF stages)
    reg [GRAY_WIDTH-1:0] rptr_gray_wclk_ff1, rptr_gray_wclk_ff2;

    // Synchronize write pointer into read clock domain (2 FF stages)
    reg [GRAY_WIDTH-1:0] wptr_gray_rclk_ff1, wptr_gray_rclk_ff2;

    // Write and read addresses to dual-port RAM (lower PTR_WIDTH bits of binary pointers)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write and read enables for RAM
    wire wwrite_en = winc & (~wfull);
    wire rread_en  = rinc & (~rempty);

    // RAM read data
    wire [WIDTH-1:0] ram_rdata;

    // --------------------------------------
    // Dual-port RAM instantiation
    // --------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wwrite_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rread_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Register output data on read enable
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rread_en)
            rdata <= ram_rdata;
    end

    // ---------------------------
    // Binary to Gray code function
    // ---------------------------
    function [GRAY_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH:0] bin_in;
        integer i;
        begin
            bin2gray[GRAY_WIDTH-1] = bin_in[PTR_WIDTH]; // MSB same
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                bin2gray[i] = bin_in[i+1] ^ bin_in[i];
        end
    endfunction

    // ---------------------------
    // Gray code to Binary function
    // ---------------------------
    function [PTR_WIDTH:0] gray2bin;
        input [GRAY_WIDTH-1:0] gray_in;
        integer j;
        begin
            gray2bin[PTR_WIDTH] = gray_in[GRAY_WIDTH-1];
            for (j = PTR_WIDTH-1; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ gray_in[j];
        end
    endfunction

    // --------------------------------------
    // Write pointer update in write clock domain
    // --------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else begin
            if (wwrite_en) begin
                wptr_bin  <= wptr_bin + 1'b1;
                wptr_gray <= bin2gray(wptr_bin + 1'b1);
            end
        end
    end

    // --------------------------------------
    // Read pointer update in read clock domain
    // --------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else begin
            if (rread_en) begin
                rptr_bin  <= rptr_bin + 1'b1;
                rptr_gray <= bin2gray(rptr_bin + 1'b1);
            end
        end
    end

    // --------------------------------------
    // Synchronize read pointer into write clock domain (2 FF stages)
    // --------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_wclk_ff1 <= 0;
            rptr_gray_wclk_ff2 <= 0;
        end else begin
            rptr_gray_wclk_ff1 <= rptr_gray;
            rptr_gray_wclk_ff2 <= rptr_gray_wclk_ff1;
        end
    end

    // --------------------------------------
    // Synchronize write pointer into read clock domain (2 FF stages)
    // --------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_rclk_ff1 <= 0;
            wptr_gray_rclk_ff2 <= 0;
        end else begin
            wptr_gray_rclk_ff1 <= wptr_gray;
            wptr_gray_rclk_ff2 <= wptr_gray_rclk_ff1;
        end
    end

    // --------------------------------------
    // Convert synchronized Gray pointers back to binary for comparison
    // --------------------------------------
    wire [PTR_WIDTH:0] rptr_bin_sync_in_wclk = gray2bin(rptr_gray_wclk_ff2);
    wire [PTR_WIDTH:0] wptr_bin_sync_in_rclk = gray2bin(wptr_gray_rclk_ff2);

    // --------------------------------------
    // FIFO FULL logic (write side)
    // FIFO is full if next write pointer equals synchronized read pointer with MSB and MSB-1 bits inverted
    // See FIFO theory for condition:
    // full = (wptr_gray_next[GRAY_WIDTH-1:GRAY_WIDTH-2] == ~rptr_gray_wclk_ff2[GRAY_WIDTH-1:GRAY_WIDTH-2])
    //        && (wptr_gray_next lower bits == rptr_gray_wclk_ff2 lower bits)
    // --------------------------------------
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [GRAY_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    wire full_cond =
        (wptr_gray_next[GRAY_WIDTH-3:0] == rptr_gray_wclk_ff2[GRAY_WIDTH-3:0]) &&
        (wptr_gray_next[GRAY_WIDTH-1] != rptr_gray_wclk_ff2[GRAY_WIDTH-1]) &&
        (wptr_gray_next[GRAY_WIDTH-2] != rptr_gray_wclk_ff2[GRAY_WIDTH-2]);

    assign wfull = full_cond;

    // --------------------------------------
    // FIFO EMPTY logic (read side)
    // FIFO is empty if read pointer equals synchronized write pointer
    // --------------------------------------
    assign rempty = (rptr_gray == wptr_gray_rclk_ff2);

endmodule


// Dual-port RAM with separate read/write clocks and enables
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                      rclk,
    input                      renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule