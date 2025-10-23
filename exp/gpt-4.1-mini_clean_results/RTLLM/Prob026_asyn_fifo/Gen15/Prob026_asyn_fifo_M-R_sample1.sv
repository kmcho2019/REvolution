`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // Active low synchronous reset for write domain
    input                   rrstn,      // Active low synchronous reset for read domain
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Function: Binary to Gray code
    function [PTR_WIDTH-1:0] bin_to_gray(input [PTR_WIDTH-1:0] bin);
        bin_to_gray = (bin >> 1) ^ bin;
    endfunction

    // Function: Gray code to Binary
    function [PTR_WIDTH-1:0] gray_to_bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin_val;
        begin
            bin_val[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin_val[i] = bin_val[i+1] ^ gray[i];
            gray_to_bin = bin_val;
        end
    endfunction

    // --------------------------------
    // Write pointer (binary + Gray)
    // --------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin_reg;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin_reg + (winc & ~wfull);
    wire [PTR_WIDTH-1:0] wptr_gray = bin_to_gray(wptr_bin_reg);
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin_to_gray(wptr_bin_next);

    always @(posedge wclk) begin
        if (~wrstn)
            wptr_bin_reg <= 0;
        else
            wptr_bin_reg <= wptr_bin_next;
    end

    // --------------------------------
    // Read pointer (binary + Gray)
    // --------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin_reg;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin_reg + (rinc & ~rempty);
    wire [PTR_WIDTH-1:0] rptr_gray = bin_to_gray(rptr_bin_reg);
    wire [PTR_WIDTH-1:0] rptr_gray_next = bin_to_gray(rptr_bin_next);

    always @(posedge rclk) begin
        if (~rrstn)
            rptr_bin_reg <= 0;
        else
            rptr_bin_reg <= rptr_bin_next;
    end

    // ---------------------------------------------------------
    // Synchronize read pointer Gray code into write clock domain
    // ---------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_gray_w_sync_0, rptr_gray_w_sync_1;
    always @(posedge wclk) begin
        if (~wrstn) begin
            rptr_gray_w_sync_0 <= 0;
            rptr_gray_w_sync_1 <= 0;
        end else begin
            rptr_gray_w_sync_0 <= rptr_gray;
            rptr_gray_w_sync_1 <= rptr_gray_w_sync_0;
        end
    end
    wire [PTR_WIDTH-1:0] rptr_gray_w = rptr_gray_w_sync_1;

    // ---------------------------------------------------------
    // Synchronize write pointer Gray code into read clock domain
    // ---------------------------------------------------------
    reg [PTR_WIDTH-1:0] wptr_gray_r_sync_0, wptr_gray_r_sync_1;
    always @(posedge rclk) begin
        if (~rrstn) begin
            wptr_gray_r_sync_0 <= 0;
            wptr_gray_r_sync_1 <= 0;
        end else begin
            wptr_gray_r_sync_0 <= wptr_gray;
            wptr_gray_r_sync_1 <= wptr_gray_r_sync_0;
        end
    end
    wire [PTR_WIDTH-1:0] wptr_gray_r = wptr_gray_r_sync_1;

    // -----------------------------------------------
    // Convert synchronized Gray codes back to binary
    // -----------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_bin_w = gray_to_bin(rptr_gray_w);
    wire [PTR_WIDTH-1:0] wptr_bin_r = gray_to_bin(wptr_gray_r);

    // -------------------------
    // Full condition generation
    // -------------------------
    // FIFO full when:
    // wptr_gray == {~rptr_gray_w[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_w[PTR_WIDTH-3:0]}
    assign wfull = (wptr_gray == {~rptr_gray_w[PTR_WIDTH-1], ~rptr_gray_w[PTR_WIDTH-2], rptr_gray_w[PTR_WIDTH-3:0]});

    // --------------------------
    // Empty condition generation
    // --------------------------
    assign rempty = (rptr_gray == wptr_gray_r);

    // ------------------------
    // Addresses for RAM ports
    // ------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin_reg[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin_reg[ADDR_WIDTH-1:0];

    // Write enable and read enable for RAM
    wire ram_wen = winc & ~wfull;
    wire ram_ren = rinc & ~rempty;

    // -------------------
    // Dual-Port RAM instantiation
    // -------------------
    wire [WIDTH-1:0] ram_rdata;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_ram_inst (
        .wclk(wclk),
        .wenc(ram_wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ram_ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -------------------
    // Register output data on read clock when read enabled
    // -------------------
    always @(posedge rclk) begin
        if (~rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (ram_ren)
            rdata <= ram_rdata;
    end

endmodule


// -------------------------------------------------
// Dual-Port RAM Module (Behavioral)
// -------------------------------------------------
module dual_port_ram #(
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