`timescale 1ns / 1ps

// Dual-port RAM with independent write/read clocks and enables
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                   wclk,
    input  wire                   wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]       wdata,
    input  wire                   rclk,
    input  wire                   renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]       rdata
);

    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire               wclk,
    input  wire               rclk,
    input  wire               wrstn,  // active low async reset write domain
    input  wire               rrstn,  // active low async reset read domain
    input  wire               winc,   // write increment (push)
    input  wire               rinc,   // read increment (pop)
    input  wire [WIDTH-1:0]   wdata,  // write data
    output wire               wfull,  // FIFO full flag
    output wire               rempty, // FIFO empty flag
    output wire [WIDTH-1:0]   rdata   // read data
);

    // -------- Binary to Gray code conversion --------
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // -------- Gray code to Binary conversion --------
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction


    // -------- Write domain logic --------
    reg [PTR_WIDTH-1:0] wptr_bin;          // write pointer binary
    reg [PTR_WIDTH-1:0] wptr_gray;         // write pointer gray
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_w; // synchronized read pointer stage1 in write clk domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync2_w; // synchronized read pointer stage2 in write clk domain

    // Write pointer increment
    wire wen = winc & (~wfull);
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_gray_sync1_w <= 0;
            rptr_gray_sync2_w <= 0;
        end else begin
            if (wen)
                wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin);

            // Synchronize read pointer from read domain into write clock domain
            rptr_gray_sync1_w <= rptr_gray_sync1_w; // stall in case no update
            rptr_gray_sync2_w <= rptr_gray_sync1_w;
        end
    end

    // Separate always block for pointer sync registers to avoid mixing increment logic
    // Synchronize rptr_gray from read domain into write domain via two flip-flops
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_async;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_sync1_w <= 0;
            rptr_gray_sync2_w <= 0;
            rptr_gray_wclk_async <= 0;
        end else begin
            rptr_gray_wclk_async <= rptr_gray_sync1_w; // dummy, will be driven externally
            rptr_gray_sync1_w <= rptr_gray_sync1_w;    // dummy
        end
    end

    // -------- Read domain logic --------
    reg [PTR_WIDTH-1:0] rptr_bin;           // read pointer binary
    reg [PTR_WIDTH-1:0] rptr_gray;          // read pointer gray
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_r;  // synchronized write pointer stage1 in read clk domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync2_r;  // synchronized write pointer stage2 in read clk domain

    // Read pointer increment
    wire ren = rinc & (~rempty);
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            wptr_gray_sync1_r <= 0;
            wptr_gray_sync2_r <= 0;
        end else begin
            if (ren)
                rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin);

            // Synchronize write pointer from write domain into read clock domain
            wptr_gray_sync1_r <= wptr_gray_sync1_r; // stall in case no update
            wptr_gray_sync2_r <= wptr_gray_sync1_r;
        end
    end

    // Separate always block for pointer sync registers to avoid mixing increment logic
    // Synchronize wptr_gray from write domain into read domain via two flip-flops
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_async;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_sync1_r <= 0;
            wptr_gray_sync2_r <= 0;
            wptr_gray_rclk_async <= 0;
        end else begin
            wptr_gray_rclk_async <= wptr_gray_sync1_r; // dummy, will be driven externally
            wptr_gray_sync1_r <= wptr_gray_sync1_r;    // dummy
        end
    end


    // -------- Synchronize pointers between clock domains --------
    // Because we can't use multiple always blocks driving same registers,
    // implement pointer synchronization via separate sync regs driven combinationally

    // Synchronize read pointer into write clock domain - two FF stages
    reg [PTR_WIDTH-1:0] rptr_gray_sync_stage1_w, rptr_gray_sync_stage2_w;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_sync_stage1_w <= 0;
            rptr_gray_sync_stage2_w <= 0;
        end else begin
            rptr_gray_sync_stage1_w <= rptr_gray;
            rptr_gray_sync_stage2_w <= rptr_gray_sync_stage1_w;
        end
    end

    // Synchronize write pointer into read clock domain - two FF stages
    reg [PTR_WIDTH-1:0] wptr_gray_sync_stage1_r, wptr_gray_sync_stage2_r;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_sync_stage1_r <= 0;
            wptr_gray_sync_stage2_r <= 0;
        end else begin
            wptr_gray_sync_stage1_r <= wptr_gray;
            wptr_gray_sync_stage2_r <= wptr_gray_sync_stage1_r;
        end
    end


    // -------- Generate flags --------

    // Compose addresses to RAM from lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable for RAM
    wire wen = winc & (~wfull);

    // Read enable for RAM
    wire ren = rinc & (~rempty);

    // Combinational full flag
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin + 1'b1);

    wire [PTR_WIDTH-1:0] rptr_gray_sync_w = rptr_gray_sync_stage2_w;

    // Full condition: next write pointer equals read pointer with top two bits inverted
    wire full_comb = (wptr_gray_next[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_sync_w[PTR_WIDTH-1:PTR_WIDTH-2]) &&
                     (wptr_gray_next[PTR_WIDTH-3:0] == rptr_gray_sync_w[PTR_WIDTH-3:0]);

    assign wfull = full_comb;

    // Combinational empty flag
    wire empty_comb = (rptr_gray == wptr_gray_sync_stage2_r);

    assign rempty = empty_comb;

    // Dual-port RAM instance
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dp_ram (
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