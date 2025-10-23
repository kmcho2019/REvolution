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
    output [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // pointer width includes MSB for full detection

    // Write pointer binary counter
    reg [PTR_WIDTH-1:0] wptr_bin;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer binary counter
    reg [PTR_WIDTH-1:0] rptr_bin;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Gray code conversion of write pointer (combinational)
    wire [PTR_WIDTH-1:0] wptr_gray;
    assign wptr_gray[PTR_WIDTH-1] = wptr_bin[PTR_WIDTH-1];
    genvar i;
    generate
        for (i=PTR_WIDTH-2; i>=0; i=i-1) begin : WR_GRAY_ASSIGN
            assign wptr_gray[i] = wptr_bin[i+1] ^ wptr_bin[i];
        end
    endgenerate

    // Gray code conversion of read pointer (combinational)
    wire [PTR_WIDTH-1:0] rptr_gray;
    assign rptr_gray[PTR_WIDTH-1] = rptr_bin[PTR_WIDTH-1];
    generate
        for (i=PTR_WIDTH-2; i>=0; i=i-1) begin : RD_GRAY_ASSIGN
            assign rptr_gray[i] = rptr_bin[i+1] ^ rptr_bin[i];
        end
    endgenerate

    // Synchronize read pointer gray code into write clock domain (two-stage flip-flops)
    reg [PTR_WIDTH-1:0] rptr_gray_sync_w_stage1, rptr_gray_sync_w_stage2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_w_stage1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync_w_stage2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync_w_stage1 <= rptr_gray;
            rptr_gray_sync_w_stage2 <= rptr_gray_sync_w_stage1;
        end
    end
    wire [PTR_WIDTH-1:0] rptr_gray_sync_w = rptr_gray_sync_w_stage2;

    // Synchronize write pointer gray code into read clock domain (two-stage flip-flops)
    reg [PTR_WIDTH-1:0] wptr_gray_sync_r_stage1, wptr_gray_sync_r_stage2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_r_stage1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync_r_stage2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync_r_stage1 <= wptr_gray;
            wptr_gray_sync_r_stage2 <= wptr_gray_sync_r_stage1;
        end
    end
    wire [PTR_WIDTH-1:0] wptr_gray_sync_r = wptr_gray_sync_r_stage2;

    // Gray to binary conversion function (for addressing)
    function [PTR_WIDTH-1:0] gray_to_bin;
        input [PTR_WIDTH-1:0] gray;
        integer j;
        begin
            gray_to_bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (j=PTR_WIDTH-2; j>=0; j=j-1) begin
                gray_to_bin[j] = gray_to_bin[j+1] ^ gray[j];
            end
        end
    endfunction

    // Convert synchronized pointers back to binary for address calculations
    wire [PTR_WIDTH-1:0] rptr_bin_sync_w = gray_to_bin(rptr_gray_sync_w);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_r = gray_to_bin(wptr_gray_sync_r);

    // FIFO full condition:
    // write pointer equals read pointer with MSB and MSB-1 inverted
    wire full_flag = (wptr_gray == {~rptr_gray_sync_w[PTR_WIDTH-1], ~rptr_gray_sync_w[PTR_WIDTH-2], rptr_gray_sync_w[PTR_WIDTH-3:0]});
    assign wfull = full_flag;

    // FIFO empty condition:
    // read pointer equals synchronized write pointer
    wire empty_flag = (rptr_gray == wptr_gray_sync_r);
    assign rempty = empty_flag;

    // Addresses for RAM come from lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write and read enables
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


// Dual-port RAM module as specified
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
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