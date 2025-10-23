`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                wclk,
    input                rclk,
    input                wrstn,
    input                rrstn,
    input                winc,
    input                rinc,
    input  [WIDTH-1:0]   wdata,
    output               wfull,
    output               rempty,
    output [WIDTH-1:0]   rdata
);

    // Derived parameters
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam ADDR_WIDTH = PTR_WIDTH;
    localparam SYNC_STAGES = 2;

    // -------- Dual-port RAM signals ---------
    reg [ADDR_WIDTH-1:0] waddr;
    reg [ADDR_WIDTH-1:0] raddr;
    wire wwrite_en;
    wire rread_en;

    // -------- Pointer registers ---------
    reg [PTR_WIDTH:0] wptr_bin;  // binary write pointer with extra MSB
    reg [PTR_WIDTH:0] wptr_gray; // gray coded write pointer
    reg [PTR_WIDTH:0] rptr_bin;  // binary read pointer
    reg [PTR_WIDTH:0] rptr_gray; // gray coded read pointer

    // -------- Synchronization registers ---------
    reg [PTR_WIDTH:0] rptr_gray_sync_wclk [SYNC_STAGES-1:0]; // sync read pointer into wclk domain
    reg [PTR_WIDTH:0] wptr_gray_sync_rclk [SYNC_STAGES-1:0]; // sync write pointer into rclk domain

    integer i;

    // -------- Gray code conversion functions --------
    function [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        integer idx;
        begin
            bin2gray[PTR_WIDTH] = bin[PTR_WIDTH];
            for (idx=PTR_WIDTH-1; idx>=0; idx=idx-1)
                bin2gray[idx] = bin[idx+1] ^ bin[idx];
        end
    endfunction

    function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer idx;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (idx=PTR_WIDTH-1; idx>=0; idx=idx-1)
                gray2bin[idx] = gray2bin[idx+1] ^ gray[idx];
        end
    endfunction

    // -------- Write pointer logic (wclk domain) --------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // -------- Read pointer logic (rclk domain) --------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // -------- Synchronize read pointer into write clock domain --------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (i=0; i<SYNC_STAGES; i=i+1)
                rptr_gray_sync_wclk[i] <= 0;
        end else begin
            rptr_gray_sync_wclk[0] <= rptr_gray;
            for (i=1; i<SYNC_STAGES; i=i+1)
                rptr_gray_sync_wclk[i] <= rptr_gray_sync_wclk[i-1];
        end
    end

    // -------- Synchronize write pointer into read clock domain --------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (i=0; i<SYNC_STAGES; i=i+1)
                wptr_gray_sync_rclk[i] <= 0;
        end else begin
            wptr_gray_sync_rclk[0] <= wptr_gray;
            for (i=1; i<SYNC_STAGES; i=i+1)
                wptr_gray_sync_rclk[i] <= wptr_gray_sync_rclk[i-1];
        end
    end

    // -------- Convert synchronized pointers back to binary --------
    wire [PTR_WIDTH:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk[SYNC_STAGES-1]);
    wire [PTR_WIDTH:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk[SYNC_STAGES-1]);

    // -------- Calculate addresses for RAM --------
    always @(*) begin
        waddr = wptr_bin[ADDR_WIDTH-1:0];
        raddr = rptr_bin[ADDR_WIDTH-1:0];
    end

    // -------- Full condition logic --------
    // FIFO is full when next write pointer's gray code equals read pointer's gray code
    // with top two bits inverted and others equal
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_WIDTH:0] wptr_gray_next = bin2gray(wptr_bin_next);

    wire full_condition = 
        (wptr_gray_next[PTR_WIDTH-2:0] == rptr_gray_sync_wclk[SYNC_STAGES-1][PTR_WIDTH-2:0]) &&
        (wptr_gray_next[PTR_WIDTH]   != rptr_gray_sync_wclk[SYNC_STAGES-1][PTR_WIDTH]) &&
        (wptr_gray_next[PTR_WIDTH-1] != rptr_gray_sync_wclk[SYNC_STAGES-1][PTR_WIDTH-1]);

    assign wfull = full_condition;

    // -------- Empty condition logic --------
    // FIFO is empty when read pointer equals synchronized write pointer in read domain
    wire empty_condition = (rptr_gray == wptr_gray_sync_rclk[SYNC_STAGES-1]);
    assign rempty = empty_condition;

    // -------- RAM write and read enable signals --------
    assign wwrite_en = winc && !wfull;
    assign rread_en = rinc && !rempty;

    // -------- Instantiate dual-port RAM --------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wwrite_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rread_en),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]  wdata,
    input                   rclk,
    input                   renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    // Memory declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule