`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // active low write reset
    input                   rrstn,   // active low read reset
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output reg              wfull,
    output reg              rempty,
    output [WIDTH-1:0]      rdata
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // ----------------------------------
    // Binary counters for write/read pointers
    // ----------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;

    // Gate the increments to prevent unnecessary toggling
    wire write_enable = winc & ~wfull;
    wire read_enable  = rinc & ~rempty;

    wire [PTR_WIDTH-1:0] wptr_bin_next = write_enable ? (wptr_bin + 1'b1) : wptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = read_enable  ? (rptr_bin + 1'b1)  : rptr_bin;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else
            wptr_bin <= wptr_bin_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else
            rptr_bin <= rptr_bin_next;
    end

    // ----------------------------------
    // Gray code conversion functions
    // ----------------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Convert binary pointers to Gray code
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // ----------------------------------
    // Synchronizers: Separate module instantiation for clarity
    // ----------------------------------
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;

    gray_sync #(.WIDTH(PTR_WIDTH)) read_ptr_sync (
        .clk(wclk),
        .rst_n(wrstn),
        .async_gray_in(rptr_gray),
        .sync_gray_out(rptr_gray_sync_wclk)
    );

    gray_sync #(.WIDTH(PTR_WIDTH)) write_ptr_sync (
        .clk(rclk),
        .rst_n(rrstn),
        .async_gray_in(wptr_gray),
        .sync_gray_out(wptr_gray_sync_rclk)
    );

    // ----------------------------------
    // Convert synchronized Gray pointers to binary for address computations
    // ----------------------------------
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    // ----------------------------------
    // RAM addresses (lowest bits of binary pointers)
    // ----------------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // ----------------------------------
    // Enable signals for RAM
    // ----------------------------------
    wire wen = write_enable;
    wire ren = read_enable;

    // ----------------------------------
    // Instantiate dual-port RAM
    // ----------------------------------
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Assign RAM output directly to rdata
    assign rdata = ram_rdata;

    // ----------------------------------
    // Registered full flag logic (updated on wclk)
    // Full when:
    // wptr_gray = inversion of MSB and next MSB of rptr_gray_sync, rest bits equal
    // ----------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= ( (wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_sync_wclk[PTR_WIDTH-1]) &&
                       (wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_sync_wclk[PTR_WIDTH-2]) &&
                       (wptr_gray[PTR_WIDTH-3:0] ==  rptr_gray_sync_wclk[PTR_WIDTH-3:0]) );
    end

    // ----------------------------------
    // Registered empty flag logic (updated on rclk)
    // Empty when read pointer equals synchronized write pointer
    // ----------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= (rptr_gray == wptr_gray_sync_rclk);
    end

endmodule


// ----------------------------------
// Two-stage synchronizer for Gray code signals
// ----------------------------------
module gray_sync #(
    parameter WIDTH = 4
)(
    input wire clk,
    input wire rst_n,
    input wire [WIDTH-1:0] async_gray_in,
    output reg [WIDTH-1:0] sync_gray_out
);
    reg [WIDTH-1:0] sync_gray_ff1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_gray_ff1 <= {WIDTH{1'b0}};
            sync_gray_out <= {WIDTH{1'b0}};
        end else begin
            sync_gray_ff1 <= async_gray_in;
            sync_gray_out <= sync_gray_ff1;
        end
    end
endmodule

// ----------------------------------
// Dual-port RAM with separate clocks and ports
// ----------------------------------
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
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end
endmodule