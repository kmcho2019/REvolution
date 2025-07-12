`timescale 1ns / 1ps

// Asynchronous FIFO with parameterizable width and depth
// Implements dual-port RAM with separate write/read clocks
// Uses Gray code pointers for pointer crossing synchronization
module asyn_fifo #(
    parameter WIDTH = 8,      // Data width
    parameter DEPTH = 16      // FIFO depth, must be a power of two
)(
    input                  wclk,    // Write clock
    input                  rclk,    // Read clock
    input                  wrstn,   // Write domain reset (active low)
    input                  rrstn,   // Read domain reset (active low)
    input                  winc,    // Write increment (write enable)
    input                  rinc,    // Read increment (read enable)
    input  [WIDTH-1:0]     wdata,   // Write data input
    output                 wfull,   // Write full flag
    output                 rempty,  // Read empty flag
    output reg [WIDTH-1:0] rdata    // Read data output
);

    // Calculate address width and pointer width (one extra bit for full detection)
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // ---- Pointer registers ----
    // Gray code write pointer and its binary version
    reg [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin;

    // Gray code read pointer and its binary version
    reg [PTR_WIDTH-1:0] rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin;

    // Synchronized pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_gray_sync_wclk_1, rptr_gray_sync_wclk_2; // rptr synchronized into wclk domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync_rclk_1, wptr_gray_sync_rclk_2; // wptr synchronized into rclk domain

    // ----- Synchronize read pointer into write clock domain -----
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk_1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync_wclk_2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync_wclk_1 <= rptr_gray;
            rptr_gray_sync_wclk_2 <= rptr_gray_sync_wclk_1;
        end
    end

    // ----- Synchronize write pointer into read clock domain -----
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk_1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync_rclk_2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync_rclk_1 <= wptr_gray;
            wptr_gray_sync_rclk_2 <= wptr_gray_sync_rclk_1;
        end
    end

    // ---------- Gray to binary conversion function ----------
    // Converts PTR_WIDTH-bit Gray code to binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1]; // MSB directly assigned
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // ---------- Binary to Gray conversion function ----------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            for (i = PTR_WIDTH-1; i > 0; i = i - 1) begin
                bin2gray[i] = bin[i] ^ bin[i-1];
            end
            bin2gray[0] = bin[0];
        end
    endfunction

    // ---------- Increment Gray code pointer ----------
    function [PTR_WIDTH-1:0] gray_increment(input [PTR_WIDTH-1:0] gray_in);
        reg [PTR_WIDTH-1:0] bin_val;
        reg [PTR_WIDTH-1:0] bin_plus1;
        begin
            bin_val = gray2bin(gray_in);
            bin_plus1 = bin_val + 1'b1;
            gray_increment = bin2gray(bin_plus1);
        end
    endfunction

    // ---- Write pointer logic (write clock domain) ----
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (winc && !wfull) begin
            wptr_gray <= gray_increment(wptr_gray);
        end
    end

    // ---- Read pointer logic (read clock domain) ----
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (rinc && !rempty) begin
            rptr_gray <= gray_increment(rptr_gray);
        end
    end

    // Convert Gray pointers to binary for address generation
    assign wptr_bin = gray2bin(wptr_gray);
    assign rptr_bin = gray2bin(rptr_gray);

    // Convert synchronized pointers
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk_2);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk_2);

    // Address extraction (lower ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Calculate next write pointer Gray code for full flag detection
    wire [PTR_WIDTH-1:0] wptr_gray_next = gray_increment(wptr_gray);

    // ---- Full flag generation ----
    // According to problem:
    // When the write pointer is one cycle ahead:
    // - The top two bits of write pointer and read pointer are inverted
    // - The remaining bits are the same
    //
    // Here, check this condition comparing wptr_gray_next and synchronized rptr_gray in write clock domain
    wire msb_inv = (wptr_gray_next[PTR_WIDTH-1] != rptr_gray_sync_wclk_2[PTR_WIDTH-1]) &&
                   (wptr_gray_next[PTR_WIDTH-2] != rptr_gray_sync_wclk_2[PTR_WIDTH-2]);

    wire rest_eq = (wptr_gray_next[ADDR_WIDTH-1:0] == rptr_gray_sync_wclk_2[ADDR_WIDTH-1:0]);

    assign wfull = msb_inv && rest_eq;

    // ---- Empty flag generation ----
    // FIFO is empty when read pointer equals synchronized write pointer in read clock domain
    assign rempty = (rptr_gray == wptr_gray_sync_rclk_2);

    // Write and read enables for RAM
    wire wren = winc && ~wfull;
    wire rden = rinc && ~rempty;

    // Read data from RAM
    wire [WIDTH-1:0] ram_rdata;

    // Register output data at read clock
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (rden) begin
            rdata <= ram_rdata;
        end
    end

    // ---- Dual-port RAM instantiation ----
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wren),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rden),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

endmodule

// Dual-port RAM module with synchronous read and write ports
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]         wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: synchronous write on wclk
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port: synchronous read on rclk
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule