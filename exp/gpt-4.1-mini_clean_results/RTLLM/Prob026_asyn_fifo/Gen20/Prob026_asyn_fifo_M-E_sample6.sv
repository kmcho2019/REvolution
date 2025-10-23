`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input               wclk,
    input               rclk,
    input               wrstn,
    input               rrstn,
    input               winc,
    input               rinc,
    input  [WIDTH-1:0]  wdata,
    output reg          wfull,
    output reg          rempty,
    output reg [WIDTH-1:0] rdata
);

    // Width of address to index RAM
    localparam ADDR_WIDTH = $clog2(DEPTH);
    // Pointer width (binary counter) with extra bit for full/empty detection
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM submodule signals
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;
    wire                  wren;
    wire                  rden;
    wire [WIDTH-1:0]      ram_rdata;

    // ------------------------------
    // Write pointer binary counter and Gray code
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_bin_next;
    reg [PTR_WIDTH-1:0] wptr_gray;
    wire wfull_next;

    // Write enable gated by not full
    wire w_enable = winc && !wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (w_enable) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    always @(*) begin
        wptr_bin_next = wptr_bin + (w_enable ? 1'b1 : 1'b0);
    end

    // Write address (lower bits)
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign wren = w_enable;

    // ------------------------------
    // Read pointer binary counter and Gray code
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_bin_next;
    reg [PTR_WIDTH-1:0] rptr_gray;
    wire rempty_next;

    // Read enable gated by not empty
    wire r_enable = rinc && !rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (r_enable) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    always @(*) begin
        rptr_bin_next = rptr_bin + (r_enable ? 1'b1 : 1'b0);
    end

    // Read address (lower bits)
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];
    assign rden = r_enable;

    // ------------------------------
    // Synchronize read pointer Gray to write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_stage1, rptr_gray_wclk_stage2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_stage1 <= 0;
            rptr_gray_wclk_stage2 <= 0;
        end else begin
            rptr_gray_wclk_stage1 <= rptr_gray;
            rptr_gray_wclk_stage2 <= rptr_gray_wclk_stage1;
        end
    end
    wire [PTR_WIDTH-1:0] rptr_bin_wclk_sync = gray2bin(rptr_gray_wclk_stage2);

    // ------------------------------
    // Synchronize write pointer Gray to read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_stage1, wptr_gray_rclk_stage2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_stage1 <= 0;
            wptr_gray_rclk_stage2 <= 0;
        end else begin
            wptr_gray_rclk_stage1 <= wptr_gray;
            wptr_gray_rclk_stage2 <= wptr_gray_rclk_stage1;
        end
    end
    wire [PTR_WIDTH-1:0] wptr_bin_rclk_sync = gray2bin(wptr_gray_rclk_stage2);

    // ------------------------------
    // Full detection logic in write clock domain:
    // FIFO is full when next write pointer equals read pointer + DEPTH (circular)
    // That means (wptr_bin_next - rptr_bin_wclk_sync) == DEPTH
    assign wfull_next = (wptr_bin_next[PTR_WIDTH-1:0] == (rptr_bin_wclk_sync + DEPTH));

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= wfull_next;
    end

    // Empty detection logic in read clock domain:
    // FIFO is empty when read pointer equals synchronized write pointer
    assign rempty_next = (rptr_bin == wptr_bin_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= rempty_next;
    end

    // ------------------------------
    // Dual port RAM instance
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram (
        .wclk(wclk),
        .wenc(wren),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rden),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Register read data output in read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rden)
            rdata <= ram_rdata;
    end

    // ------------------------------
    // Functions for Gray code conversion

    // Binary to Gray code
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Gray code to binary
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

endmodule


// Dual-port RAM module with independent clocks and enables
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,
    input                    wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]       wdata,
    input                    rclk,
    input                    renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]   rdata
);

    // Memory storage
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