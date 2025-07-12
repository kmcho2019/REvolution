`timescale 1ns / 1ps

// Two-stage synchronizer module for crossing clock domains
module pointer_sync #(
    parameter WIDTH = 5
)(
    input wire clk,
    input wire rstn,
    input wire [WIDTH-1:0] din,
    output wire [WIDTH-1:0] dout
);
    reg [WIDTH-1:0] meta_ff, sync_ff;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            meta_ff <= {WIDTH{1'b0}};
            sync_ff <= {WIDTH{1'b0}};
        end else begin
            meta_ff <= din;
            sync_ff <= meta_ff;
        end
    end
    assign dout = sync_ff;
endmodule


// Dual-port RAM module with separate read and write clocks
module dp_ram_async_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input wire wclk,
    input wire wenc,
    input wire [ADDR_WIDTH-1:0] waddr,
    input wire [WIDTH-1:0] wdata,

    input wire rclk,
    input wire renc,
    input wire [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
        else
            rdata <= rdata; // hold last data
    end

endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH), // e.g. 4 for DEPTH=16
    parameter PTR_WIDTH = ADDR_WIDTH + 1  // extra bit for full/empty detection
)(
    input  wire                wclk,
    input  wire                rclk,
    input  wire                wrstn,
    input  wire                rrstn,
    input  wire                winc,
    input  wire                rinc,
    input  wire [WIDTH-1:0]    wdata,
    output wire                wfull,
    output wire                rempty,
    output wire [WIDTH-1:0]    rdata
);

    // --- Pointer registers: binary format ---
    reg [PTR_WIDTH-1:0] wbin_ptr_r, rbin_ptr_r;
    wire [PTR_WIDTH-1:0] wbin_ptr_nxt = wbin_ptr_r + (winc & ~wfull);
    wire [PTR_WIDTH-1:0] rbin_ptr_nxt = rbin_ptr_r + (rinc & ~rempty);

    // --- Gray code conversion functions ---
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

    // --- Gray pointers ---
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wbin_ptr_r);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rbin_ptr_r);

    // --- Synchronize pointers across clock domains ---
    wire [PTR_WIDTH-1:0] rptr_gray_sync_in_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_in_rclk;

    pointer_sync #(.WIDTH(PTR_WIDTH)) sync_rptr_to_wclk (
        .clk(wclk), .rstn(wrstn),
        .din(rptr_gray),
        .dout(rptr_gray_sync_in_wclk)
    );

    pointer_sync #(.WIDTH(PTR_WIDTH)) sync_wptr_to_rclk (
        .clk(rclk), .rstn(rrstn),
        .din(wptr_gray),
        .dout(wptr_gray_sync_in_rclk)
    );

    // --- Extract binary pointers from synchronized Gray ---
    wire [PTR_WIDTH-1:0] rbin_ptr_sync_in_wclk = gray2bin(rptr_gray_sync_in_wclk);
    wire [PTR_WIDTH-1:0] wbin_ptr_sync_in_rclk = gray2bin(wptr_gray_sync_in_rclk);

    // --- Write and read addresses to RAM are lower ADDR_WIDTH bits ---
    wire [ADDR_WIDTH-1:0] waddr_ram = wbin_ptr_r[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = rbin_ptr_r[ADDR_WIDTH-1:0];

    // --- RAM write and read enables ---
    wire ram_wen = winc & ~wfull;
    wire ram_ren = rinc & ~rempty;

    // --- Instantiate dual-port RAM ---
    dp_ram_async_fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dp_ram_inst (
        .wclk(wclk),
        .wenc(ram_wen),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ram_ren),
        .raddr(raddr_ram),
        .rdata(rdata)
    );

    // --- Sequential pointer updates ---
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin_ptr_r <= 0;
        end else begin
            wbin_ptr_r <= wbin_ptr_nxt;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin_ptr_r <= 0;
        end else begin
            rbin_ptr_r <= rbin_ptr_nxt;
        end
    end

    // --- Full flag combinational logic in wclk domain ---
    // Full when write pointer is one ahead of read pointer with MSBs inverted
    // wptr == {~rptr[PTR_WIDTH-1], ~rptr[PTR_WIDTH-2], rptr[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_inv_msb_bits = {~rptr_gray_sync_in_wclk[PTR_WIDTH-1], ~rptr_gray_sync_in_wclk[PTR_WIDTH-2], rptr_gray_sync_in_wclk[PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray == rptr_inv_msb_bits);

    // --- Empty flag combinational logic in rclk domain ---
    // Empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_in_rclk);

endmodule