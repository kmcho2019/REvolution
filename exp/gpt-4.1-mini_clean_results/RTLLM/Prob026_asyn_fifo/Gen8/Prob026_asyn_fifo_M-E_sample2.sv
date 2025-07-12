`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,      // active low reset for write domain
    input                  rrstn,      // active low reset for read domain
    input                  winc,
    input                  rinc,
    input  [WIDTH-1:0]     wdata,
    output                 wfull,
    output                 rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // ---- Dual-port RAM instance ----
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;
    wire                  w_en;
    wire                  r_en;
    wire [WIDTH-1:0]      ram_rdata;

    // ---- Binary Write Pointer ----
    wire [PTR_WIDTH-1:0] wptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_bin;
    // ---- Binary Read Pointer ----
    wire [PTR_WIDTH-1:0] rptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_bin;

    // ---- Gray coded pointers ----
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] rptr_gray;

    // ---- Synchronized opposite pointers ----
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;

    // ---- Full and empty signals ----
    wire full;
    wire empty;

    // ---- Write Pointer Control ----
    write_pointer_ctrl #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .PTR_WIDTH(PTR_WIDTH)
    ) wptr_ctrl (
        .wclk(wclk),
        .wrstn(wrstn),
        .winc(winc),
        .rptr_gray_sync(rptr_gray_sync_wclk),
        .wptr_bin(wptr_bin),
        .wptr_gray(wptr_gray),
        .wptr_bin_next(wptr_bin_next),
        .full(full)
    );

    // ---- Read Pointer Control ----
    read_pointer_ctrl #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .PTR_WIDTH(PTR_WIDTH)
    ) rptr_ctrl (
        .rclk(rclk),
        .rrstn(rrstn),
        .rinc(rinc),
        .wptr_gray_sync(wptr_gray_sync_rclk),
        .rptr_bin(rptr_bin),
        .rptr_gray(rptr_gray),
        .rptr_bin_next(rptr_bin_next),
        .empty(empty)
    );

    // ---- Pointer Synchronizers ----
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

    // ---- RAM Address and Enables ----
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];
    assign w_en  = winc & ~full;
    assign r_en  = rinc & ~empty;

    // ---- Read Data register ----
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn) 
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // ---- Dual-port RAM Instantiation ----
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


// =====================================================================
// Write Pointer Control Module
// Calculates next pointer, converts to Gray, and detects full.
// =====================================================================
module write_pointer_ctrl #(
    parameter ADDR_WIDTH = 4,
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input                   wclk,
    input                   wrstn,
    input                   winc,
    input       [PTR_WIDTH-1:0] rptr_gray_sync,
    output reg [PTR_WIDTH-1:0] wptr_bin,
    output     [PTR_WIDTH-1:0] wptr_gray,
    output reg [PTR_WIDTH-1:0] wptr_bin_next,
    output reg                full
);
    // Calculate next binary pointer
    wire [PTR_WIDTH-1:0] wptr_bin_next_comb = wptr_bin + (winc && !full ? 1'b1 : 1'b0);
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next_comb;
    end

    // Hold next pointer for full detection
    always @(*) begin
        wptr_bin_next = wptr_bin + 1'b1;
    end

    // Convert binary pointer to Gray code
    assign wptr_gray = binary_to_gray(wptr_bin);

    wire [PTR_WIDTH-1:0] wptr_gray_next = binary_to_gray(wptr_bin + 1'b1);

    // Full detection logic:
    // Full if next wptr_gray equals rptr_gray_sync with MSB and MSB-1 bits inverted and rest equal
    wire msb_invert_match = 
        (wptr_gray_next[PTR_WIDTH-1]   == ~rptr_gray_sync[PTR_WIDTH-1]) &&
        (wptr_gray_next[PTR_WIDTH-2]   == ~rptr_gray_sync[PTR_WIDTH-2]) &&
        (wptr_gray_next[PTR_WIDTH-3:0] ==  rptr_gray_sync[PTR_WIDTH-3:0]);

    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn)
            full <= 1'b0;
        else
            full <= msb_invert_match;
    end

    // ---- Binary to Gray function ----
    function [PTR_WIDTH-1:0] binary_to_gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            binary_to_gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                binary_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction
endmodule


// =====================================================================
// Read Pointer Control Module
// Calculates next pointer, converts to Gray, and detects empty.
// =====================================================================
module read_pointer_ctrl #(
    parameter ADDR_WIDTH = 4,
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input                   rclk,
    input                   rrstn,
    input                   rinc,
    input       [PTR_WIDTH-1:0] wptr_gray_sync,
    output reg [PTR_WIDTH-1:0] rptr_bin,
    output     [PTR_WIDTH-1:0] rptr_gray,
    output reg [PTR_WIDTH-1:0] rptr_bin_next,
    output reg                empty
);

    wire [PTR_WIDTH-1:0] rptr_bin_next_comb = rptr_bin + (rinc && !empty ? 1'b1 : 1'b0);
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next_comb;
    end

    always @(*) begin
        rptr_bin_next = rptr_bin + 1'b1;
    end

    assign rptr_gray = binary_to_gray(rptr_bin);

    // Empty detection: empty if synchronized write pointer equals read pointer
    wire empty_comb = (wptr_gray_sync == rptr_gray);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            empty <= 1'b1;
        else
            empty <= empty_comb;
    end

    // ---- Binary to Gray function ----
    function [PTR_WIDTH-1:0] binary_to_gray;
        input [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            binary_to_gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                binary_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction
endmodule


// =====================================================================
// Pointer Synchronizer Module (2-stage synchronizer)
// Synchronizes Gray coded pointer from source clock domain to destination.
// =====================================================================
module pointer_sync #(
    parameter PTR_WIDTH = 5
)(
    input                   clk_dst,
    input                   rstn,
    input      [PTR_WIDTH-1:0] ptr_in,
    output reg [PTR_WIDTH-1:0] ptr_sync
);
    reg [PTR_WIDTH-1:0] sync_stage1;

    always @(posedge clk_dst or negedge rstn) begin
        if (!rstn) begin
            sync_stage1 <= 0;
            ptr_sync   <= 0;
        end else begin
            sync_stage1 <= ptr_in;
            ptr_sync   <= sync_stage1;
        end
    end
endmodule


// =====================================================================
// Dual-port RAM Module with independent read and write clocks.
// Simple synchronous RAM with synchronous write and read enables.
// =====================================================================
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