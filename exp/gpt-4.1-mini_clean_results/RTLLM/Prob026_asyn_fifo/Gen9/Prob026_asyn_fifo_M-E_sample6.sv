`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active-low reset for write domain
    input                   rrstn,      // active-low reset for read domain
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    // Derived parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // -------------------------
    // Write Pointer and Gray
    // -------------------------
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] rptr_gray_sync_to_wclk;

    // -------------------------
    // Read Pointer and Gray
    // -------------------------
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_gray;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_to_rclk;

    // -------------------------
    // Write pointer binary counter update
    // -------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1'b1;
        end
    end

    // -------------------------
    // Read pointer binary counter update
    // -------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1'b1;
        end
    end

    // -------------------------
    // Convert binary pointers to Gray code
    // -------------------------
    binary_to_gray #(.WIDTH(PTR_WIDTH)) b2g_w (
        .bin(wptr_bin),
        .gray(wptr_gray)
    );

    binary_to_gray #(.WIDTH(PTR_WIDTH)) b2g_r (
        .bin(rptr_bin),
        .gray(rptr_gray)
    );

    // -------------------------
    // Synchronize read pointer Gray code into write clock domain
    // -------------------------
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_rptr_to_w (
        .clk(wclk),
        .rstn(wrstn),
        .gray_in(rptr_gray),
        .gray_out(rptr_gray_sync_to_wclk)
    );

    // -------------------------
    // Synchronize write pointer Gray code into read clock domain
    // -------------------------
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_wptr_to_r (
        .clk(rclk),
        .rstn(rrstn),
        .gray_in(wptr_gray),
        .gray_out(wptr_gray_sync_to_rclk)
    );

    // -------------------------
    // Full flag logic (write clock domain)
    // Condition: wptr_next_gray == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync[PTR_WIDTH-3:0]}
    // -------------------------
    wire [PTR_WIDTH-1:0] wptr_bin_next_wire = wptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] wptr_gray_next;
    binary_to_gray #(.WIDTH(PTR_WIDTH)) b2g_w_next (
        .bin(wptr_bin_next_wire),
        .gray(wptr_gray_next)
    );

    wire full_cond = (wptr_gray_next[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_sync_to_wclk[PTR_WIDTH-1:PTR_WIDTH-2])
                     && (wptr_gray_next[PTR_WIDTH-3:0] == rptr_gray_sync_to_wclk[PTR_WIDTH-3:0]);

    reg wfull_reg;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull_reg <= 1'b0;
        else
            wfull_reg <= full_cond;
    end

    assign wfull = wfull_reg;

    // -------------------------
    // Empty flag logic (read clock domain)
    // Condition: rptr_gray == wptr_gray_sync_to_rclk
    // -------------------------
    wire empty_cond = (rptr_gray == wptr_gray_sync_to_rclk);

    reg rempty_reg;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty_reg <= 1'b1;
        else
            rempty_reg <= empty_cond;
    end
    assign rempty = rempty_reg;

    // -------------------------
    // RAM interface
    // -------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    wire [WIDTH-1:0] ram_rdata;

    // Register output data on read clock domain when read enable asserted
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (r_en)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

    // -------------------------
    // Instantiate dual-port RAM
    // -------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
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

// -----------------------------
// Module: binary_to_gray
// Converts a binary number to Gray code
// -----------------------------
module binary_to_gray #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] bin,
    output [WIDTH-1:0] gray
);
    assign gray = (bin >> 1) ^ bin;
endmodule

// -----------------------------
// Module: gray_to_binary
// Converts a Gray code number to binary
// Note: This module is not used directly here but could be used for debug/test
// -----------------------------
module gray_to_binary #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] gray,
    output [WIDTH-1:0] bin
);
    integer i;
    reg [WIDTH-1:0] bin_reg;
    always @* begin
        bin_reg[WIDTH-1] = gray[WIDTH-1];
        for (i = WIDTH-2; i >= 0; i = i - 1) begin
            bin_reg[i] = bin_reg[i+1] ^ gray[i];
        end
    end
    assign bin = bin_reg;
endmodule

// -----------------------------
// Module: gray_sync
// 2-stage synchronizer for Gray code crossing clock domains
// -----------------------------
module gray_sync #(
    parameter WIDTH = 4
)(
    input                  clk,
    input                  rstn,
    input  [WIDTH-1:0]     gray_in,
    output reg [WIDTH-1:0] gray_out
);
    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_stage1 <= 0;
            gray_out <= 0;
        end else begin
            sync_stage1 <= gray_in;
            gray_out <= sync_stage1;
        end
    end
endmodule

// -----------------------------
// Module: dual_port_RAM
// Simple dual-port RAM with independent read/write clocks and enables
// -----------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]      wdata,
    input                       rclk,
    input                       renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);
    // Memory array
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