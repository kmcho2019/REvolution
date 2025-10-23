`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input              wclk,
    input              rclk,
    input              wrstn,   // active low reset in write domain
    input              rrstn,   // active low reset in read domain
    input              winc,    // write increment (write enable)
    input              rinc,    // read increment (read enable)
    input  [WIDTH-1:0] wdata,   // data input to write
    output             wfull,   // full flag in write domain
    output             rempty,  // empty flag in read domain
    output [WIDTH-1:0] rdata    // data output from FIFO
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // extra bit for full/empty detection

    // ----------------------------------------------------------------
    // Binary and Gray code pointer registers in write domain
    // ----------------------------------------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_gray;

    // ----------------------------------------------------------------
    // Binary and Gray code pointer registers in read domain
    // ----------------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_gray;

    // ----------------------------------------------------------------
    // Pointer synchronizers (Gray code) crossing clock domains
    // ----------------------------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;

    // ----------------------------------------------------------------
    // Pointer synchronization submodule (two-stage synchronizer)
    // ----------------------------------------------------------------
    // Synchronize read pointer into write clock domain
    ptr_synchronizer #(
        .WIDTH(PTR_WIDTH)
    ) readptr_sync_inst (
        .clk_dst(wclk),
        .rstn_dst(wrstn),
        .in_ptr(rptr_gray),
        .out_ptr(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer into read clock domain
    ptr_synchronizer #(
        .WIDTH(PTR_WIDTH)
    ) writeptr_sync_inst (
        .clk_dst(rclk),
        .rstn_dst(rrstn),
        .in_ptr(wptr_gray),
        .out_ptr(wptr_gray_sync_rclk)
    );

    // ----------------------------------------------------------------
    // Gray code conversion functions
    // ----------------------------------------------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // ----------------------------------------------------------------
    // Write pointer binary increment
    // Only increment if not full and winc asserted
    // ----------------------------------------------------------------
    always @(*) begin
        if (winc && !wfull)
            wptr_bin_next = wptr_bin + 1'b1;
        else
            wptr_bin_next = wptr_bin;
    end

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    // Convert write pointer binary to Gray
    assign wptr_gray = bin2gray(wptr_bin);

    // ----------------------------------------------------------------
    // Read pointer binary increment
    // Only increment if not empty and rinc asserted
    // ----------------------------------------------------------------
    always @(*) begin
        if (rinc && !rempty)
            rptr_bin_next = rptr_bin + 1'b1;
        else
            rptr_bin_next = rptr_bin;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    // Convert read pointer binary to Gray
    assign rptr_gray = bin2gray(rptr_bin);

    // ----------------------------------------------------------------
    // Full and Empty detection
    // For full: next write pointer (wptr_bin + 1) equals read pointer synchronized in write domain
    // For empty: read pointer equals write pointer synchronized in read domain
    // Note: use binary pointers for comparison
    // ----------------------------------------------------------------

    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    wire [PTR_WIDTH-1:0] wptr_bin_next_inc = wptr_bin + 1'b1;

    assign wfull = (wptr_bin_next_inc == rptr_bin_sync_wclk);
    assign rempty = (rptr_bin == wptr_bin_sync_rclk);

    // ----------------------------------------------------------------
    // Extract RAM addresses (lowest ADDR_WIDTH bits of binary pointers)
    // ----------------------------------------------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write and read enables for RAM
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // ----------------------------------------------------------------
    // Dual-port RAM instance for data storage
    // ----------------------------------------------------------------
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    assign rdata = ram_rdata;

endmodule


// ----------------------------------------------------------------------
// Pointer synchronizer module: 2-stage flip-flop synchronizer for Gray code pointer
// ----------------------------------------------------------------------
module ptr_synchronizer #(
    parameter WIDTH = 5
) (
    input                  clk_dst,
    input                  rstn_dst,
    input  [WIDTH-1:0]     in_ptr,
    output reg [WIDTH-1:0] out_ptr
);

    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk_dst or negedge rstn_dst) begin
        if (!rstn_dst) begin
            sync_stage1 <= 0;
            out_ptr <= 0;
        end else begin
            sync_stage1 <= in_ptr;
            out_ptr <= sync_stage1;
        end
    end

endmodule


// ----------------------------------------------------------------------
// Dual-port RAM behavioral model with independent clocks
// ----------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read operation (registered read)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end else begin
            rdata <= rdata; // hold last data
        end
    end

endmodule