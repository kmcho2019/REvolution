`timescale 1ns / 1ps

module asyn_fifo #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // Active-low write domain reset
    input                   rrstn,   // Active-low read domain reset
    input                   winc,    // Write increment (write enable)
    input                   rinc,    // Read increment (read enable)
    input      [WIDTH-1:0]  wdata,   // Data input for writing
    output                  wfull,   // FIFO full flag
    output                  rempty,  // FIFO empty flag
    output reg [WIDTH-1:0]  rdata    // Data output for reading
);

    // Pointer widths:
    // PTR_WIDTH: bits needed for DEPTH addressing (e.g. 4 bits for 16 entries)
    // PTR_EXT_WIDTH: PTR_WIDTH + 1 extra MSB bit for full/empty distinction
    localparam integer PTR_WIDTH     = (DEPTH > 1) ? $clog2(DEPTH) : 1;
    localparam integer PTR_EXT_WIDTH = PTR_WIDTH + 1;

    // -------------------------------
    // Binary pointers in respective clock domains
    reg [PTR_EXT_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin = 0;

    // Gray code pointers (generated combinationally)
    wire [PTR_EXT_WIDTH-1:0] wptr_gray;
    wire [PTR_EXT_WIDTH-1:0] rptr_gray;

    // Synchronized Gray pointers crossing domains
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk;

    // Binary pointers synchronized across domains (converted from synchronized Gray)
    wire [PTR_EXT_WIDTH-1:0] rptr_bin_sync_wclk;
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_sync_rclk;

    // Write and read enable gated with full/empty flags
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Write and read RAM addresses use lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Read data from RAM
    wire [WIDTH-1:0] ram_rdata;

    // -------------------------------
    // Functions for Gray code conversions
    // Binary to Gray code conversion
    function automatic [PTR_EXT_WIDTH-1:0] binary_to_gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            binary_to_gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for (i = PTR_EXT_WIDTH-2; i >= 0; i = i -1)
                binary_to_gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to Binary code conversion
    function automatic [PTR_EXT_WIDTH-1:0] gray_to_binary;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray_to_binary[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j = PTR_EXT_WIDTH-2; j >= 0; j = j -1)
                gray_to_binary[j] = gray_to_binary[j+1] ^ gray[j];
        end
    endfunction

    // -------------------------------
    // Write pointer logic (in write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= {PTR_EXT_WIDTH{1'b0}};
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
        end
    end

    // Read pointer logic (in read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= {PTR_EXT_WIDTH{1'b0}};
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
        end
    end

    // Generate Gray codes from binary pointers (combinational)
    assign wptr_gray = binary_to_gray(wptr_bin);
    assign rptr_gray = binary_to_gray(rptr_bin);

    // -------------------------------
    // Two-stage synchronizers for pointer crossing between clock domains

    // Synchronize read pointer Gray code to write clock domain
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer Gray code to read clock domain
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Convert synchronized Gray pointers back to binary for simplified comparison
    assign rptr_bin_sync_wclk = gray_to_binary(rptr_gray_sync_wclk);
    assign wptr_bin_sync_rclk = gray_to_binary(wptr_gray_sync_rclk);

    // -------------------------------
    // Full and empty flags logic in respective clock domains

    // Full condition detected in write clock domain:
    // FIFO is full when next write pointer equals read pointer with MSB and MSB-1 bits inverted,
    // and other bits equal. This condition means FIFO has one slot left.
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    assign wfull = ( (wptr_bin_next[PTR_EXT_WIDTH-1:PTR_EXT_WIDTH-2] == ~rptr_bin_sync_wclk[PTR_EXT_WIDTH-1:PTR_EXT_WIDTH-2]) &&
                     (wptr_bin_next[PTR_EXT_WIDTH-3:0] == rptr_bin_sync_wclk[PTR_EXT_WIDTH-3:0]) );

    // Empty condition detected in read clock domain:
    // FIFO is empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_bin == wptr_bin_sync_rclk);

    // -------------------------------
    // Read data register: updated on read clock with valid read enable
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= ram_rdata;
        end
    end

    // -------------------------------
    // Instantiate dual-port RAM for asynchronous data storage
    asyn_fifo_dual_port_ram #(
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


// -------------------------------------------------
// Two-stage synchronizer for multi-bit signals crossing clock domains
// This reduces metastability risks when sampling asynchronous signals
module synchronizer #(
    parameter integer WIDTH = 4
)(
    input                 clk,
    input                 rst_n,  // Active-low reset
    input  [WIDTH-1:0]    in,
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


// -------------------------------------------------
// Dual-port RAM module optimized for asynchronous FIFO use
// Separate clocks for write and read ports, synchronous write and read
module asyn_fifo_dual_port_ram #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 16
)(
    input                          wclk,
    input                          wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]         wdata,
    input                          rclk,
    input                          renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]         rdata
);

    // RAM memory array: DEPTH deep, WIDTH wide
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation on write clock domain
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read operation on read clock domain
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule