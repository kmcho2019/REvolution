`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,   // active low write domain reset
    input                  rrstn,   // active low read domain reset
    input                  winc,    // write increment request
    input                  rinc,    // read increment request
    input       [WIDTH-1:0] wdata,
    output                 wfull,
    output                 rempty,
    output reg  [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);      // address width (e.g. 4 for DEPTH=16)
    localparam PTR_EXT = PTR_WIDTH + 1;        // pointer width including MSB for wrap-around distinction

    // Dual-port RAM signals
    wire [PTR_WIDTH-1:0] waddr;
    wire [PTR_WIDTH-1:0] raddr;
    wire w_en;
    wire r_en;
    wire [WIDTH-1:0] ram_rdata;

    // Write and read binary pointers
    reg [PTR_EXT-1:0] wptr_bin;
    reg [PTR_EXT-1:0] rptr_bin;

    // Write and read Gray pointers
    reg [PTR_EXT-1:0] wptr_gray;
    reg [PTR_EXT-1:0] rptr_gray;

    // Synchronized pointers crossing clock domains
    wire [PTR_EXT-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT-1:0] wptr_gray_sync_rclk;

    // Write enable only if not full and winc asserted
    assign w_en = winc & ~wfull;
    // Read enable only if not empty and rinc asserted
    assign r_en = rinc & ~rempty;

    assign waddr = wptr_bin[PTR_WIDTH-1:0];
    assign raddr = rptr_bin[PTR_WIDTH-1:0];

    // Binary to Gray conversion function
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_EXT-1] = bin[PTR_EXT-1];
            for(i = PTR_EXT-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to Binary conversion function
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for (i=PTR_EXT-2; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction


    // WRITE CONTROLLER: increment write pointer on w_en
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // READ CONTROLLER: increment read pointer on r_en
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // READ POINTER SYNCHRONIZER - synchronize rptr_gray into write clock domain
    ptr_sync #(PTR_EXT) read_ptr_sync_inst (
        .clk(wclk),
        .rst_n(wrstn),
        .async_ptr(rptr_gray),
        .sync_ptr(rptr_gray_sync_wclk)
    );

    // WRITE POINTER SYNCHRONIZER - synchronize wptr_gray into read clock domain
    ptr_sync #(PTR_EXT) write_ptr_sync_inst (
        .clk(rclk),
        .rst_n(rrstn),
        .async_ptr(wptr_gray),
        .sync_ptr(wptr_gray_sync_rclk)
    );

    // FULL FLAG LOGIC: compare wptr_gray_next to synchronized rptr_gray in wclk domain
    wire [PTR_EXT-1:0] wptr_gray_next = bin2gray(wptr_bin + 1'b1);

    // FIFO full when:
    // MSB and next MSB of wptr_gray_next differ from those bits of rptr_gray_sync_wclk,
    // AND remaining bits equal
    assign wfull = (
        (wptr_gray_next[PTR_EXT-3:0] == rptr_gray_sync_wclk[PTR_EXT-3:0]) &&
        (wptr_gray_next[PTR_EXT-1] != rptr_gray_sync_wclk[PTR_EXT-1]) &&
        (wptr_gray_next[PTR_EXT-2] != rptr_gray_sync_wclk[PTR_EXT-2])
    );

    // EMPTY FLAG LOGIC: compare rptr_gray to synchronized wptr_gray in rclk domain
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // REGISTER OUTPUT DATA ONLY WHEN READING
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // DUAL PORT RAM: instantiated with parameters and interfaces matching
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram (
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


// ----------------------------
// Pointer synchronizer module
// Two-flip-flop synchronizer for multi-bit Gray code pointers crossing clock domains
module ptr_sync #(
    parameter PTR_WIDTH = 5
)(
    input                  clk,
    input                  rst_n,
    input  [PTR_WIDTH-1:0] async_ptr,
    output reg [PTR_WIDTH-1:0] sync_ptr
);
    reg [PTR_WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= 0;
            sync_ptr <= 0;
        end else begin
            sync_ff1 <= async_ptr;
            sync_ptr <= sync_ff1;
        end
    end
endmodule


// ----------------------------
// Dual-port RAM Module:
// Depth and width configurable
// Write port is synchronous to wclk, read port synchronous to rclk
// Write enable controls write operation
// Read enable controls read operation
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0] wdata,
    input                  rclk,
    input                  renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    // RAM array declaration
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    // Read port: synchronous read with enable
    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule