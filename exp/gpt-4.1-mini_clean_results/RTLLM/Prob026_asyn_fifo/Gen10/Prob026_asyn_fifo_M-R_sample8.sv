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
    input      [WIDTH-1:0] wdata,
    output                 wfull,
    output                 rempty,
    output reg [WIDTH-1:0] rdata
);
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1;

    // Write pointer registers (Gray code)
    reg [PTR_EXT-1:0] wptr_gray_r = 0;
    reg [PTR_EXT-1:0] wptr_bin_r = 0;

    // Read pointer registers (Gray code)
    reg [PTR_EXT-1:0] rptr_gray_r = 0;
    reg [PTR_EXT-1:0] rptr_bin_r = 0;

    // Synchronizers: read pointer into write clock domain
    reg [PTR_EXT-1:0] rptr_gray_sync1 = 0, rptr_gray_sync2 = 0;

    // Synchronizers: write pointer into read clock domain
    reg [PTR_EXT-1:0] wptr_gray_sync1 = 0, wptr_gray_sync2 = 0;

    // Write enable and read enable (masked by full/empty)
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Write pointer binary increment and Gray conversion
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin_r + (w_en ? 1'b1 : 1'b0);
    wire [PTR_EXT-1:0] wptr_gray_next;
    genvar i;
    generate
        for (i=PTR_EXT-1; i>0; i=i-1) begin : gen_gray_w
            assign wptr_gray_next[i] = wptr_bin_next[i] ^ wptr_bin_next[i-1];
        end
        assign wptr_gray_next[0] = wptr_bin_next[0];
    endgenerate

    // Read pointer binary increment and Gray conversion
    wire [PTR_EXT-1:0] rptr_bin_next = rptr_bin_r + (r_en ? 1'b1 : 1'b0);
    wire [PTR_EXT-1:0] rptr_gray_next;
    generate
        for (i=PTR_EXT-1; i>0; i=i-1) begin : gen_gray_r
            assign rptr_gray_next[i] = rptr_bin_next[i] ^ rptr_bin_next[i-1];
        end
        assign rptr_gray_next[0] = rptr_bin_next[0];
    endgenerate

    // Write pointer update (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin_r <= 0;
            wptr_gray_r <= 0;
        end else begin
            if (w_en) begin
                wptr_bin_r <= wptr_bin_next;
                wptr_gray_r <= wptr_gray_next;
            end
        end
    end

    // Read pointer update (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin_r <= 0;
            rptr_gray_r <= 0;
        end else begin
            if (r_en) begin
                rptr_bin_r <= rptr_bin_next;
                rptr_gray_r <= rptr_gray_next;
            end
        end
    end

    // Synchronize read pointer Gray code into write clock domain (2-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray_r;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Synchronize write pointer Gray code into read clock domain (2-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray_r;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Extract binary addresses for RAM from binary pointers (lower PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin_r[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin_r[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Full detection logic:
    // FIFO full if next write pointer equals read pointer with MSB and MSB-1 inverted
    wire full_condition = 
        (wptr_gray_next[PTR_EXT-3:0] == rptr_gray_sync2[PTR_EXT-3:0]) &&
        (wptr_gray_next[PTR_EXT-1]   != rptr_gray_sync2[PTR_EXT-1]) &&
        (wptr_gray_next[PTR_EXT-2]   != rptr_gray_sync2[PTR_EXT-2]);
    assign wfull = full_condition;

    // Empty detection logic: FIFO empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray_r == wptr_gray_sync2);

    // Register read data output, update on read enable and rising edge of read clock
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Dual-port RAM instance
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


// Dual-port RAM submodule with separate clocks, synchronous write and read
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                         wclk,
    input                         wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]        wdata,
    input                         rclk,
    input                         renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]        rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule