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

    // Binary pointers for write and read domains
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;

    // Gray code pointers (for synchronization and full/empty detection)
    wire [PTR_WIDTH-1:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // Synchronize read pointer Gray code into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Synchronize write pointer Gray code into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Increment write pointer in write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Increment read pointer in read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Extract RAM addresses (lower bits of binary pointers)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable signal
    wire wen = winc && !wfull;

    // Full condition:
    // FIFO is full when:
    // - MSB and next MSB of wptr_gray differ from those of synchronized rptr_gray (inverted),
    // - and lower bits are equal.
    assign wfull = ((wptr_gray[PTR_WIDTH-1] != rptr_gray_sync2[PTR_WIDTH-1]) &&
                    (wptr_gray[PTR_WIDTH-2] != rptr_gray_sync2[PTR_WIDTH-2]) &&
                    (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync2[PTR_WIDTH-3:0]));

    // Empty condition: read pointer Gray equals synchronized write pointer Gray
    assign rempty = (rptr_gray == wptr_gray_sync2);

    // Instantiate dual-port RAM submodule
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

// Dual-port RAM module with synchronous write and read clocks
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

    always @(posedge wclk)
        if (wenc)
            mem[waddr] <= wdata;

    always @(posedge rclk)
        if (renc)
            rdata <= mem[raddr];

endmodule