`timescale 1ns/1ps

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
    output [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Write and read pointers in binary
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;

    // Gray-coded pointers
    wire [PTR_WIDTH-1:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // Synchronizers for cross-clock domain pointer signals
    wire [PTR_WIDTH-1:0] rptr_gray_wclk, wptr_gray_rclk;

    gray_sync #(.WIDTH(PTR_WIDTH)) rptr_sync (
        .clk(wclk), .rstn(wrstn),
        .in_gray(rptr_gray), .out_gray(rptr_gray_wclk)
    );
    gray_sync #(.WIDTH(PTR_WIDTH)) wptr_sync (
        .clk(rclk), .rstn(rrstn),
        .in_gray(wptr_gray), .out_gray(wptr_gray_rclk)
    );

    // Increment pointers
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Extract RAM addresses from lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire wen = winc && !wfull;

    // Full detection: write pointer is one ahead of read pointer with upper bits inverted
    assign wfull = ( (wptr_gray[PTR_WIDTH-1] != rptr_gray_wclk[PTR_WIDTH-1]) &&
                     (wptr_gray[PTR_WIDTH-2] != rptr_gray_wclk[PTR_WIDTH-2]) &&
                     (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_wclk[PTR_WIDTH-3:0]) );

    // Empty detection: read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk);

    // Dual-port RAM instantiation
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(1'b1),     // Always enable read, data valid next cycle
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule

// Dual-port RAM with synchronous write/read
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]         wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];
endmodule

// Two-stage synchronizer for Gray-coded pointer crossing clock domains
module gray_sync #(
    parameter WIDTH = 5
)(
    input                   clk,
    input                   rstn,
    input  [WIDTH-1:0]      in_gray,
    output reg [WIDTH-1:0]  out_gray
);

    reg [WIDTH-1:0] ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ff1 <= 0;
            out_gray <= 0;
        end else begin
            ff1 <= in_gray;
            out_gray <= ff1;
        end
    end
endmodule