`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                  wclk,
    input  wire                  wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,

    input  wire                  rclk,
    input  wire                  renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output wire [WIDTH-1:0]      rdata
);

    // Dual port RAM with synchronous write and asynchronous read
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] raddr_reg;

    // Write port: synchronous write on wclk
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Register read address on read clock when renc asserted
    always @(posedge rclk) begin
        if (renc)
            raddr_reg <= raddr;
    end

    // Asynchronous read from registered address
    assign rdata = mem[raddr_reg];

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
    output wire                 wfull,
    output wire                 rempty,
    output wire [WIDTH-1:0]     rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary to Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray code to binary conversion
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

    // Write pointer in binary and gray
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Read pointer in binary and gray
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronize read pointer into write clock domain (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] rptr_gray_sync_wclk_0, rptr_gray_sync_wclk_1;

    // Synchronize write pointer into read clock domain (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] wptr_gray_sync_rclk_0, wptr_gray_sync_rclk_1;

    // Write pointer update
    wire w_full_int;
    wire w_en = winc & ~w_full_int;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer update
    wire r_empty_int;
    wire r_en = rinc & ~r_empty_int;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk_0 <= 0;
            rptr_gray_sync_wclk_1 <= 0;
        end else begin
            rptr_gray_sync_wclk_0 <= rptr_gray;
            rptr_gray_sync_wclk_1 <= rptr_gray_sync_wclk_0;
        end
    end

    // Synchronize write pointer to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk_0 <= 0;
            wptr_gray_sync_rclk_1 <= 0;
        end else begin
            wptr_gray_sync_rclk_0 <= wptr_gray;
            wptr_gray_sync_rclk_1 <= wptr_gray_sync_rclk_0;
        end
    end

    // Convert synchronized pointers to binary for address calculation
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk_1);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk_1);

    // Full flag generation:
    // FIFO is full when write pointer's MSB and MSB-1 bits are the complement of read pointer's MSB and MSB-1 bits,
    // and the rest bits are equal.
    assign w_full_int = ( (wptr_gray[PTR_WIDTH-1]   != rptr_gray_sync_wclk_1[PTR_WIDTH-1]) &&
                         (wptr_gray[PTR_WIDTH-2]   != rptr_gray_sync_wclk_1[PTR_WIDTH-2]) &&
                         (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync_wclk_1[PTR_WIDTH-3:0]) );

    // Empty flag generation: FIFO is empty when read pointer equals synchronized write pointer
    assign r_empty_int = (rptr_gray == wptr_gray_sync_rclk_1);

    // Output full and empty signals synchronized to their respective clocks
    reg wfull_reg, rempty_reg;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull_reg <= 1'b0;
        else
            wfull_reg <= w_full_int;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty_reg <= 1'b1;
        else
            rempty_reg <= r_empty_int;
    end

    assign wfull  = wfull_reg;
    assign rempty = rempty_reg;

    // Extract RAM addresses from binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule