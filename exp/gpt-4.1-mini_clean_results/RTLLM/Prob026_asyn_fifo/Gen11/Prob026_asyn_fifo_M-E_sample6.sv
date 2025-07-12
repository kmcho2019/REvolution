`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,       // Write clock
    input                   rclk,       // Read clock
    input                   wrstn,      // Active low write domain reset
    input                   rrstn,      // Active low read domain reset
    input                   winc,       // Write enable increment
    input                   rinc,       // Read enable increment
    input  [WIDTH-1:0]      wdata,      // Write data input
    output                  wfull,      // Write full flag
    output                  rempty,     // Read empty flag
    output [WIDTH-1:0]      rdata       // Read data output
);

    // Calculate address and pointer widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ===== Pointer registers (binary) =====
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // ===== Gray code pointers =====
    wire [PTR_WIDTH-1:0] wptr_gray = bin_to_gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin_to_gray(rptr_bin);

    // ===== Synchronizers for pointers crossing clock domains =====
    // Synchronize read pointer (Gray) into write clock domain
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    gray_pointer_sync #(.WIDTH(PTR_WIDTH)) sync_rptr_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .async_gray_in(rptr_gray),
        .sync_gray_out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer (Gray) into read clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;
    gray_pointer_sync #(.WIDTH(PTR_WIDTH)) sync_wptr_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .async_gray_in(wptr_gray),
        .sync_gray_out(wptr_gray_sync_rclk)
    );

    // ===== Convert synchronized Gray pointers back to binary =====
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray_to_bin(rptr_gray_sync_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray_to_bin(wptr_gray_sync_rclk);

    // ===== Next pointers =====
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc && !wfull ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc && !rempty ? 1'b1 : 1'b0);

    // ===== Full flag generation =====
    // FIFO full when: upper two bits of wptr_gray are inverse of upper two bits of rptr_gray_sync_wclk,
    // and lower bits are equal
    // That means:
    //   wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_sync_wclk[PTR_WIDTH-1]
    //   wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_sync_wclk[PTR_WIDTH-2]
    //   wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_WIDTH-3:0]
    wire full_flag = ( (wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_sync_wclk[PTR_WIDTH-1]) &&
                       (wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_sync_wclk[PTR_WIDTH-2]) &&
                       (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_WIDTH-3:0]) );

    // ===== Empty flag generation =====
    // FIFO empty when read pointer Gray equals synchronized write pointer Gray
    wire empty_flag = (rptr_gray == wptr_gray_sync_rclk);

    // ===== Pointer updates =====
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= {PTR_WIDTH{1'b0}};
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= {PTR_WIDTH{1'b0}};
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
        end
    end

    assign wfull  = full_flag;
    assign rempty = empty_flag;

    // ===== RAM interface =====
    // Extract address from lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;
    wire [WIDTH-1:0] ram_rdata;

    // Register read data on read clock domain for stable output
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata_reg <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata_reg <= ram_rdata;
        end
    end
    assign rdata = rdata_reg;

    // ===== Instantiate dual-port RAM =====
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // ===== Functions for binary <-> Gray code conversion =====

    function [PTR_WIDTH-1:0] bin_to_gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin_to_gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    function [PTR_WIDTH-1:0] gray_to_bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray_to_bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
            end
        end
    endfunction

endmodule


// =========================================
// dual-port RAM module
// Simple synchronous dual-port RAM with independent read/write clocks and enable signals
// =========================================
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                     wclk,
    input                     wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]    wdata,

    input                     rclk,
    input                     renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]    rdata
);

    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write port - synchronous to wclk
    always @(posedge wclk) begin
        if (wenc) begin
            ram_mem[waddr] <= wdata;
        end
    end

    // Read port - synchronous to rclk
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= ram_mem[raddr];
        end
    end

endmodule


// =========================================
// Gray code synchronizer module for crossing clock domains
// Uses two-stage flip-flops to safely transfer Gray code pointers
// =========================================
module gray_pointer_sync #(
    parameter WIDTH = 5
)(
    input  clk,
    input  rstn,                   // Active low reset
    input  [WIDTH-1:0] async_gray_in,
    output [WIDTH-1:0] sync_gray_out
);

    reg [WIDTH-1:0] sync_ff1, sync_ff2;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= {WIDTH{1'b0}};
            sync_ff2 <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= async_gray_in;
            sync_ff2 <= sync_ff1;
        end
    end

    assign sync_gray_out = sync_ff2;

endmodule