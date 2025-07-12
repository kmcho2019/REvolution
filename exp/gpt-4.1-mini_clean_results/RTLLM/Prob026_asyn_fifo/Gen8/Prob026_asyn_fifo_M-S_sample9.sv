`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low write reset
    input                   rrstn,      // active low read reset
    input                   winc,       // write increment (write enable pulse)
    input                   rinc,       // read increment (read enable pulse)
    input  [WIDTH-1:0]      wdata,
    output reg              wfull,
    output reg              rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary write pointer and Gray-coded write pointer
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + ((winc & ~wfull) ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            if (winc & ~wfull) begin
                wptr_bin <= wptr_bin_next;
                wptr_gray <= wptr_gray_next;
            end
        end
    end

    // Binary read pointer and Gray-coded read pointer
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + ((rinc & ~rempty) ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] rptr_gray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            if (rinc & ~rempty) begin
                rptr_bin <= rptr_bin_next;
                rptr_gray <= rptr_gray_next;
            end
        end
    end

    // Two-stage synchronizers for Gray pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Function: Gray code to binary conversion
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    wire [PTR_WIDTH-1:0] rptr_sync_bin = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] wptr_sync_bin = gray2bin(wptr_gray_rclk_sync);

    // Full condition (write clock domain):
    // FIFO is full when write pointer next value has MSB and next MSB bits inverted compared to read pointer synchronized in write clock domain,
    // and lower bits are equal.
    wire full_cond = (wptr_gray_next[PTR_WIDTH-1]   == ~rptr_gray_wclk_sync[PTR_WIDTH-1]) &&
                     (wptr_gray_next[PTR_WIDTH-2]   == ~rptr_gray_wclk_sync[PTR_WIDTH-2]) &&
                     (wptr_gray_next[PTR_WIDTH-3:0] ==  rptr_gray_wclk_sync[PTR_WIDTH-3:0]);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_cond;
    end

    // Empty condition (read clock domain):
    // FIFO is empty when read pointer equals synchronized write pointer in read clock domain.
    wire empty_cond = (rptr_gray == wptr_gray_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_cond;
    end

    // RAM addressing uses lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM write and read enables
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM output data
    wire [WIDTH-1:0] ram_rdata;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM submodule
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_RAM_inst (
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