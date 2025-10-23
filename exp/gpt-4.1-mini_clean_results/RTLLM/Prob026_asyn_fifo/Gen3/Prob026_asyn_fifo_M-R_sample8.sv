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
    output reg [WIDTH-1:0] rdata
);

    // Address width (pointer width)
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam GRAY_WIDTH = PTR_WIDTH + 1;

    // -----------------------------
    // Pointer binary registers
    // -----------------------------
    reg [PTR_WIDTH:0] wptr_bin;
    reg [PTR_WIDTH:0] rptr_bin;

    // -----------------------------
    // Pointer gray code registers
    // -----------------------------
    reg [GRAY_WIDTH-1:0] wptr_gray;
    reg [GRAY_WIDTH-1:0] rptr_gray;

    // -----------------------------
    // Synchronizer registers
    // -----------------------------
    reg [GRAY_WIDTH-1:0] rptr_gray_wclk_ff1, rptr_gray_wclk_ff2;
    reg [GRAY_WIDTH-1:0] wptr_gray_rclk_ff1, wptr_gray_rclk_ff2;

    // -----------------------------
    // RAM address wires
    // -----------------------------
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // -----------------------------
    // Write and read enable wires
    // -----------------------------
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // -----------------------------
    // RAM read data wire
    // -----------------------------
    wire [WIDTH-1:0] ram_rdata;

    // -----------------------------
    // Functions for Gray/Bin conversion
    // -----------------------------
    function [GRAY_WIDTH-1:0] bin2gray(input [PTR_WIDTH:0] bin);
        integer i;
        begin
            bin2gray[GRAY_WIDTH-1] = bin[PTR_WIDTH];
            for (i = PTR_WIDTH - 1; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH:0] gray2bin(input [GRAY_WIDTH-1:0] gray);
        integer j;
        begin
            gray2bin[PTR_WIDTH] = gray[GRAY_WIDTH-1];
            for (j = PTR_WIDTH - 1; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

    // -----------------------------
    // Write pointer logic (write clock domain)
    // -----------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // -----------------------------
    // Read pointer logic (read clock domain)
    // -----------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // -----------------------------
    // Synchronize read pointer into write clock domain (two FFs)
    // -----------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_wclk_ff1 <= 0;
            rptr_gray_wclk_ff2 <= 0;
        end else begin
            rptr_gray_wclk_ff1 <= rptr_gray;
            rptr_gray_wclk_ff2 <= rptr_gray_wclk_ff1;
        end
    end

    // -----------------------------
    // Synchronize write pointer into read clock domain (two FFs)
    // -----------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_rclk_ff1 <= 0;
            wptr_gray_rclk_ff2 <= 0;
        end else begin
            wptr_gray_rclk_ff1 <= wptr_gray;
            wptr_gray_rclk_ff2 <= wptr_gray_rclk_ff1;
        end
    end

    // -----------------------------
    // Convert synchronized Gray pointers to binary
    // -----------------------------
    wire [PTR_WIDTH:0] rptr_bin_sync = gray2bin(rptr_gray_wclk_ff2);
    wire [PTR_WIDTH:0] wptr_bin_sync = gray2bin(wptr_gray_rclk_ff2);

    // -----------------------------
    // Next write pointer (for full detection)
    // -----------------------------
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [GRAY_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // -----------------------------
    // Full flag combinational logic
    // -----------------------------
    assign wfull =
        (wptr_gray_next[GRAY_WIDTH-3:0] == rptr_gray_wclk_ff2[GRAY_WIDTH-3:0]) &&
        (wptr_gray_next[GRAY_WIDTH-1] != rptr_gray_wclk_ff2[GRAY_WIDTH-1]) &&
        (wptr_gray_next[GRAY_WIDTH-2] != rptr_gray_wclk_ff2[GRAY_WIDTH-2]);

    // -----------------------------
    // Empty flag combinational logic
    // -----------------------------
    assign rempty = (rptr_gray == wptr_gray_rclk_ff2);

    // -----------------------------
    // Register output data on read enable
    // -----------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // -----------------------------
    // Instantiate dual-port RAM
    // -----------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

endmodule


// ----------------------------------------------------
// Dual-port RAM module with independent clocks & enables
// ----------------------------------------------------
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

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule