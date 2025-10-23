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

    // Binary write pointer
    reg [PTR_WIDTH-1:0] wptr_bin;
    // Binary read pointer
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray code write pointer (continuous assignment)
    wire [PTR_WIDTH-1:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    // Gray code read pointer (continuous assignment)
    wire [PTR_WIDTH-1:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // Two-stage synchronizer registers for rptr_gray into wclk domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk;
    reg [PTR_WIDTH-1:0] rptr_gray_sync2_wclk;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_wclk <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync2_wclk <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Two-stage synchronizer registers for wptr_gray into rclk domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk;
    reg [PTR_WIDTH-1:0] wptr_gray_sync2_rclk;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_rclk <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync2_rclk <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // Write pointer increment logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer increment logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Extract RAM addresses from binary pointers (lower bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable when winc asserted and FIFO not full
    wire wen = winc && !wfull;

    // Full condition combinational logic:
    // When:
    // - upper two bits of wptr_gray == inverse of corresponding bits of synchronized rptr_gray in write domain
    // - lower bits are equal
    wire full_upper_match = (wptr_gray[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_sync2_wclk[PTR_WIDTH-1:PTR_WIDTH-2]);
    wire full_lower_match = (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync2_wclk[PTR_WIDTH-3:0]);
    assign wfull = full_upper_match && full_lower_match;

    // Empty condition combinational logic:
    // FIFO empty when read pointer Gray equals synchronized write pointer Gray in read domain
    assign rempty = (rptr_gray == wptr_gray_sync2_rclk);

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
        .renc(1'b1), // always enable read port
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


// Dual-port RAM module definition
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