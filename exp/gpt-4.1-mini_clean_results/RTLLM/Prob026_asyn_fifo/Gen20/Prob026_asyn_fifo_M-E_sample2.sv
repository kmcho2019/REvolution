`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,    // Write clock domain clock
    input                  rclk,    // Read clock domain clock
    input                  wrstn,   // Write domain async reset (active low)
    input                  rrstn,   // Read domain async reset (active low)
    input                  winc,    // Write increment (write enable)
    input                  rinc,    // Read increment (read enable)
    input      [WIDTH-1:0] wdata,   // Write data input
    output                 wfull,   // Write full flag
    output                 rempty,  // Read empty flag
    output reg [WIDTH-1:0] rdata    // Read data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // One extra bit for full/empty distinction

    // -------- Write Domain --------
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] wptr_gray_next;

    wire winc_en = winc & ~wfull;

    // Increment write pointer binary and gray
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (winc_en) begin
            wptr_bin  <= wptr_bin + 1;
            wptr_gray <= ((wptr_bin + 1) ^ ((wptr_bin + 1) >> 1));
        end
    end

    // -------- Read Domain --------
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    wire rinc_en = rinc & ~rempty;

    // Increment read pointer binary and gray
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (rinc_en) begin
            rptr_bin  <= rptr_bin + 1;
            rptr_gray <= ((rptr_bin + 1) ^ ((rptr_bin + 1) >> 1));
        end
    end

    // -------- Synchronize Pointers --------

    // Synchronize read pointer Gray code into write clock domain
    wire [PTR_WIDTH-1:0] rptr_gray_sync_w;
    synchronizer #(.WIDTH(PTR_WIDTH)) sync_rptr_to_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .in_signal(rptr_gray),
        .out_signal(rptr_gray_sync_w)
    );

    // Synchronize write pointer Gray code into read clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_sync_r;
    synchronizer #(.WIDTH(PTR_WIDTH)) sync_wptr_to_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .in_signal(wptr_gray),
        .out_signal(wptr_gray_sync_r)
    );

    // -------- Gray to Binary conversion --------
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // -------- FIFO Full detection (write domain) --------
    // Condition: FIFO is full when write pointer is one ahead of read pointer with specific bit inversion in Gray code:
    // wfull when wptr_gray == {~rptr_gray_sync_w[PTR_WIDTH-1], ~rptr_gray_sync_w[PTR_WIDTH-2], rptr_gray_sync_w[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_gray_inv_msb_bits = {
        ~rptr_gray_sync_w[PTR_WIDTH-1],
        ~rptr_gray_sync_w[PTR_WIDTH-2],
        rptr_gray_sync_w[PTR_WIDTH-3:0]
    };
    assign wfull = (wptr_gray == rptr_gray_inv_msb_bits);

    // -------- FIFO Empty detection (read domain) --------
    // Condition: FIFO is empty when read pointer equals synchronized write pointer Gray code
    assign rempty = (rptr_gray == wptr_gray_sync_r);

    // -------- RAM Addressing --------
    // Address inputs derived from the binary pointers (lower ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable only if write increment and FIFO not full
    wire wen = winc_en;
    // Read enable only if read increment and FIFO not empty
    wire ren = rinc_en;

    wire [WIDTH-1:0] ram_rdata;

    // -------- Dual-port RAM instantiation --------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -------- Registered output data on read clock --------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (ren)
            rdata <= ram_rdata;
    end

endmodule


// -------- Two-stage synchronizer for asynchronous crossing --------
module synchronizer #(
    parameter WIDTH = 1
)(
    input                 clk,
    input                 rstn,
    input  [WIDTH-1:0]    in_signal,
    output reg [WIDTH-1:0] out_signal
);
    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_stage1 <= {WIDTH{1'b0}};
            out_signal  <= {WIDTH{1'b0}};
        end else begin
            sync_stage1 <= in_signal;
            out_signal  <= sync_stage1;
        end
    end
endmodule


// -------- Parameterizable dual-port RAM --------
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

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule