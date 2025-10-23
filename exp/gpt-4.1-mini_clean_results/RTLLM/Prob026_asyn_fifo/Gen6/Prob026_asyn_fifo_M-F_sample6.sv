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
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    // Pointer width parameters
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1;  // One extra bit for full/empty distinction
    localparam ADDR_WIDTH = PTR_WIDTH;          // Address width matches DEPTH

    // Binary write pointer and Gray-coded write pointer
    reg [PTR_EXT_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_EXT_WIDTH-1:0] wptr_gray = 0;

    // Binary read pointer and Gray-coded read pointer
    reg [PTR_EXT_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_EXT_WIDTH-1:0] rptr_gray = 0;

    // Synchronized pointers crossing clock domains
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk;

    // Write enable gated with full flag
    wire w_en = winc & (~wfull);
    // Read enable gated with empty flag
    wire r_en = rinc & (~rempty);

    // RAM addresses derived from lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM data output wire
    wire [WIDTH-1:0] ram_rdata;

    // Binary to Gray code conversion function
    function [PTR_EXT_WIDTH-1:0] bin2gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for (i = PTR_EXT_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray code to Binary conversion function
    function [PTR_EXT_WIDTH-1:0] gray2bin;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j = PTR_EXT_WIDTH-2; j >= 0; j = j - 1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

    // Write pointer update (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer update (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer (Gray) into write clock domain
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer (Gray) into read clock domain
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Calculate next write pointer Gray code (for full detection)
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // Full condition detection:
    // FIFO is full when next write pointer Gray matches read pointer Gray with MSB and second MSB inverted
    wire full_condition = 
        (wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_EXT_WIDTH-3:0]) &&
        (wptr_gray_next[PTR_EXT_WIDTH-1] != rptr_gray_sync_wclk[PTR_EXT_WIDTH-1]) &&
        (wptr_gray_next[PTR_EXT_WIDTH-2] != rptr_gray_sync_wclk[PTR_EXT_WIDTH-2]);

    assign wfull = full_condition;

    // Empty condition detection:
    // FIFO is empty when read pointer Gray equals synchronized write pointer Gray
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Register read data on read clock when read enable asserted
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

    // Dual-port RAM instantiation
    dual_port_RAM_async_fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dual_port_ram_inst (
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


// Two-stage synchronizer for multi-bit signals (Gray-coded pointer synchronizer)
module synchronizer #(
    parameter WIDTH = 4
)(
    input              clk,
    input              rst_n,
    input  [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= {WIDTH{1'b0}};
            out      <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= in;
            out      <= sync_ff1;
        end
    end

endmodule


// Dual-port RAM module used by asynchronous FIFO
module dual_port_RAM_async_fifo #(
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

    // RAM storage array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (synchronous write)
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port (synchronous read)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule