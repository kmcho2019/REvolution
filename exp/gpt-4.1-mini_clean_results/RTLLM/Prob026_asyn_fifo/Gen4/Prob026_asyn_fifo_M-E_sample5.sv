`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam GRAY_WIDTH = PTR_WIDTH + 1;

    // -------- Write Pointer Binary Counter --------
    wire [PTR_WIDTH:0] wbin_next;
    wire [PTR_WIDTH:0] wbin;
    wire [PTR_WIDTH:0] wbin_inc;
    assign wbin_inc = wbin + 1'b1;

    bin_counter #(.WIDTH(PTR_WIDTH+1)) u_wbin_counter (
        .clk(wclk),
        .rstn(wrstn),
        .inc(winc & ~wfull),
        .count(wbin)
    );

    assign wbin_next = winc & ~wfull ? wbin_inc : wbin;

    // -------- Read Pointer Binary Counter --------
    wire [PTR_WIDTH:0] rbin_next;
    wire [PTR_WIDTH:0] rbin;
    wire [PTR_WIDTH:0] rbin_inc;
    assign rbin_inc = rbin + 1'b1;

    bin_counter #(.WIDTH(PTR_WIDTH+1)) u_rbin_counter (
        .clk(rclk),
        .rstn(rrstn),
        .inc(rinc & ~rempty),
        .count(rbin)
    );

    assign rbin_next = rinc & ~rempty ? rbin_inc : rbin;

    // -------- Gray code conversion --------
    wire [GRAY_WIDTH-1:0] wptr_gray;
    wire [GRAY_WIDTH-1:0] rptr_gray;

    bin2gray #(.WIDTH(PTR_WIDTH+1)) u_bin2gray_w (
        .bin(wbin),
        .gray(wptr_gray)
    );

    bin2gray #(.WIDTH(PTR_WIDTH+1)) u_bin2gray_r (
        .bin(rbin),
        .gray(rptr_gray)
    );

    // -------- Synchronizers --------
    // Synchronize rptr_gray into wclk domain
    wire [GRAY_WIDTH-1:0] rptr_gray_sync_wclk;
    synchronizer #(.WIDTH(GRAY_WIDTH)) u_sync_rptr_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .async_in(rptr_gray),
        .sync_out(rptr_gray_sync_wclk)
    );

    // Synchronize wptr_gray into rclk domain
    wire [GRAY_WIDTH-1:0] wptr_gray_sync_rclk;
    synchronizer #(.WIDTH(GRAY_WIDTH)) u_sync_wptr_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .async_in(wptr_gray),
        .sync_out(wptr_gray_sync_rclk)
    );

    // -------- Convert synchronized Gray to binary --------
    wire [PTR_WIDTH:0] rbin_sync_wclk;
    wire [PTR_WIDTH:0] wbin_sync_rclk;

    gray2bin #(.WIDTH(PTR_WIDTH+1)) u_gray2bin_r_wclk (
        .gray(rptr_gray_sync_wclk),
        .bin(rbin_sync_wclk)
    );

    gray2bin #(.WIDTH(PTR_WIDTH+1)) u_gray2bin_w_rclk (
        .gray(wptr_gray_sync_rclk),
        .bin(wbin_sync_rclk)
    );

    // -------- FIFO Full Logic (in wclk domain) --------
    // Full when next write pointer equals read pointer with top two bits inverted
    wire full_condition;
    assign full_condition = (
        ( (wbin_next[PTR_WIDTH]     != rbin_sync_wclk[PTR_WIDTH]) ) &&
        ( (wbin_next[PTR_WIDTH-1]   != rbin_sync_wclk[PTR_WIDTH-1]) ) &&
        ( (wbin_next[PTR_WIDTH-2:0] == rbin_sync_wclk[PTR_WIDTH-2:0]) )
    );
    assign wfull = full_condition;

    // -------- FIFO Empty Logic (in rclk domain) --------
    // Empty when read pointer equals synchronized write pointer
    wire empty_condition;
    assign empty_condition = (rbin == wbin_sync_rclk);
    assign rempty = empty_condition;

    // -------- RAM addressing --------
    // Extract lower PTR_WIDTH bits from binary pointers for addressing dual-port RAM
    wire [PTR_WIDTH-1:0] waddr = wbin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rbin[PTR_WIDTH-1:0];

    // -------- Write and Read enable for RAM --------
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // -------- Dual-port RAM --------
    wire [WIDTH-1:0] ram_rdata;

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

    // -------- Register read data --------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

endmodule


// ---------------------------
// Binary Counter with enable and async reset
// ---------------------------
module bin_counter #(
    parameter WIDTH = 4
)(
    input               clk,
    input               rstn,
    input               inc,
    output reg [WIDTH-1:0] count
);
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            count <= 0;
        else if (inc)
            count <= count + 1'b1;
        else
            count <= count;
    end
endmodule


// ---------------------------
// Binary to Gray code converter (param WIDTH)
// ---------------------------
module bin2gray #(
    parameter WIDTH = 4  // binary width
)(
    input  [WIDTH-1:0] bin,
    output [WIDTH-1:0] gray
);
    genvar i;
    generate
        for (i = 0; i < WIDTH-1; i = i + 1) begin : gen_gray
            assign gray[i] = bin[i+1] ^ bin[i];
        end
    endgenerate
    assign gray[WIDTH-1] = bin[WIDTH-1];
endmodule


// ---------------------------
// Gray code to Binary converter (param WIDTH)
// ---------------------------
module gray2bin #(
    parameter WIDTH = 4  // gray code width
)(
    input  [WIDTH-1:0] gray,
    output [WIDTH-1:0] bin
);
    genvar j;
    assign bin[WIDTH-1] = gray[WIDTH-1];
    generate
        for (j = WIDTH-2; j >= 0; j = j - 1) begin : gen_bin
            assign bin[j] = bin[j+1] ^ gray[j];
        end
    endgenerate
endmodule


// ---------------------------
// Two-stage synchronizer for multi-bit signals (param WIDTH)
// ---------------------------
module synchronizer #(
    parameter WIDTH = 4
)(
    input               clk,
    input               rstn,
    input  [WIDTH-1:0]  async_in,
    output reg [WIDTH-1:0] sync_out
);
    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= 0;
            sync_out <= 0;
        end else begin
            sync_ff1 <= async_in;
            sync_out <= sync_ff1;
        end
    end
endmodule


// ---------------------------
// Dual-port RAM with independent clocks and enables
// ---------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]          wdata,
    input                       rclk,
    input                       renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
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