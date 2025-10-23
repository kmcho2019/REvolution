`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low write reset
    input                   rrstn,      // active low read reset
    input                   winc,
    input                   rinc,
    input       [WIDTH-1:0] wdata,
    output reg              wfull,
    output reg              rempty,
    output reg  [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // Write pointer signals
    reg  [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray;
    reg  [PTR_WIDTH-1:0] wptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_gray_next;

    // Read pointer signals
    reg  [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray;
    reg  [PTR_WIDTH-1:0] rptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_gray_next;

    // Synchronized Gray pointers (opposite clock domain)
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;

    // RAM addressing
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM enables
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM data output
    wire [WIDTH-1:0] ram_rdata;

    // ------------------------------------------------------------------------
    // Binary to Gray conversion function (common for write and read pointers)
    // ------------------------------------------------------------------------
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // ------------------------------------------------------------------------
    // Gray to Binary conversion function (for optional debugging or extensions)
    // Not used in this FIFO, but useful if needed.
    // ------------------------------------------------------------------------
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // ------------------------------------------------------------------------
    // Write pointer logic
    // ------------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else if (w_en)
            wptr_bin <= wptr_bin + 1'b1;
    end

    assign wptr_gray      = bin2gray(wptr_bin);
    assign wptr_bin_next  = wptr_bin + 1'b1;
    assign wptr_gray_next = bin2gray(wptr_bin_next);

    // ------------------------------------------------------------------------
    // Read pointer logic
    // ------------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else if(r_en)
            rptr_bin <= rptr_bin + 1'b1;
    end

    assign rptr_gray      = bin2gray(rptr_bin);
    assign rptr_bin_next  = rptr_bin + 1'b1;
    assign rptr_gray_next = bin2gray(rptr_bin_next);

    // ------------------------------------------------------------------------
    // Pointer synchronizers
    // Synchronize read pointer Gray to write clock domain
    // Synchronize write pointer Gray to read clock domain
    // ------------------------------------------------------------------------
    pointer_sync #(
        .PTR_WIDTH(PTR_WIDTH)
    ) rptr_sync_inst (
        .clk_dst(wclk),
        .rstn(wrstn),
        .ptr_in(rptr_gray),
        .ptr_sync(rptr_gray_sync_wclk)
    );

    pointer_sync #(
        .PTR_WIDTH(PTR_WIDTH)
    ) wptr_sync_inst (
        .clk_dst(rclk),
        .rstn(rrstn),
        .ptr_in(wptr_gray),
        .ptr_sync(wptr_gray_sync_rclk)
    );

    // ------------------------------------------------------------------------
    // Full signal generation (write clock domain)
    // FIFO is full when next write pointer = read pointer with MSB & MSB-1 bits inverted
    // ------------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn)
            wfull <= 1'b0;
        else begin
            // Condition: next write pointer Gray equals read pointer Gray with MSB and MSB-1 inverted
            wfull <= (wptr_gray_next[PTR_WIDTH-1]   == ~rptr_gray_sync_wclk[PTR_WIDTH-1]) &&
                     (wptr_gray_next[PTR_WIDTH-2]   == ~rptr_gray_sync_wclk[PTR_WIDTH-2]) &&
                     (wptr_gray_next[PTR_WIDTH-3:0] ==  rptr_gray_sync_wclk[PTR_WIDTH-3:0]);
        end
    end

    // ------------------------------------------------------------------------
    // Empty signal generation (read clock domain)
    // FIFO is empty when synchronized write pointer Gray equals read pointer Gray
    // ------------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            rempty <= 1'b1;
        else
            rempty <= (wptr_gray_sync_rclk == rptr_gray);
    end

    // ------------------------------------------------------------------------
    // Read data register
    // Register RAM output on every clock, use read enable to update output only when data is valid
    // This reduces glitches and improves timing.
    // ------------------------------------------------------------------------
    reg [WIDTH-1:0] ram_rdata_d;
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            ram_rdata_d <= {WIDTH{1'b0}};
        else
            ram_rdata_d <= ram_rdata;
    end

    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata_d;
    end

    // ------------------------------------------------------------------------
    // Dual-port RAM instantiation
    // ------------------------------------------------------------------------
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

// ===========================================================================
// Pointer synchronizer: 2-stage synchronizer for Gray pointers between clock domains
// ===========================================================================
module pointer_sync #(
    parameter PTR_WIDTH = 5
)(
    input  wire               clk_dst,
    input  wire               rstn,
    input  wire [PTR_WIDTH-1:0] ptr_in,
    output reg  [PTR_WIDTH-1:0] ptr_sync
);

    reg [PTR_WIDTH-1:0] sync_stage1;

    always @(posedge clk_dst or negedge rstn) begin
        if(!rstn) begin
            sync_stage1 <= {PTR_WIDTH{1'b0}};
            ptr_sync    <= {PTR_WIDTH{1'b0}};
        end else begin
            sync_stage1 <= ptr_in;
            ptr_sync    <= sync_stage1;
        end
    end

endmodule

// ===========================================================================
// Dual-port RAM with independent clocks for write/read
// Synchronous write and read with enable signals.
// ===========================================================================
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                      wclk,
    input  wire                      wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]          wdata,
    input  wire                      rclk,
    input  wire                      renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]          rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if(wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if(renc)
            rdata <= mem[raddr];
    end

endmodule