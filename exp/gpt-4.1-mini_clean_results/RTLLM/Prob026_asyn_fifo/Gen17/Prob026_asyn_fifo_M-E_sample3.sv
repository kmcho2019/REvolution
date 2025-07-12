`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,   // active low async reset for write domain
    input                 rrstn,   // active low async reset for read domain
    input                 winc,    // write increment (push)
    input                 rinc,    // read increment (pop)
    input  [WIDTH-1:0]    wdata,   // input write data
    output                wfull,   // FIFO full flag
    output                rempty,  // FIFO empty flag
    output [WIDTH-1:0]    rdata    // output read data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Internal pointers width: ADDR_WIDTH+1 (extra bit for full/empty detection)
    // WRITE SIDE POINTERS
    reg  [ADDR_WIDTH:0] wbin = 0;          // Write pointer binary (write clock domain)
    reg  [ADDR_WIDTH:0] wgray = 0;         // Write pointer Gray code
    wire [ADDR_WIDTH:0] wbin_next;
    wire [ADDR_WIDTH:0] wgray_next;

    // READ SIDE POINTERS
    reg  [ADDR_WIDTH:0] rbin = 0;          // Read pointer binary (read clock domain)
    reg  [ADDR_WIDTH:0] rgray = 0;         // Read pointer Gray code
    wire [ADDR_WIDTH:0] rbin_next;
    wire [ADDR_WIDTH:0] rgray_next;

    // SYNCHRONIZED POINTERS (gray code) crossing clock domains
    // Read pointer synchronized into write clock domain
    wire [ADDR_WIDTH:0] rgray_sync_wclk;
    // Write pointer synchronized into read clock domain
    wire [ADDR_WIDTH:0] wgray_sync_rclk;

    // === PART 4: Read pointer synchronizer (read pointer -> write clock domain) ===
    sync_gray #(
        .WIDTH(ADDR_WIDTH+1)
    ) read_ptr_sync_wclk (
        .dest_clk(wclk),
        .dest_rstn(wrstn),
        .async_ptr(rgray),
        .sync_ptr(rgray_sync_wclk)
    );

    // === PART 5: Write pointer synchronizer (write pointer -> read clock domain) ===
    sync_gray #(
        .WIDTH(ADDR_WIDTH+1)
    ) write_ptr_sync_rclk (
        .dest_clk(rclk),
        .dest_rstn(rrstn),
        .async_ptr(wgray),
        .sync_ptr(wgray_sync_rclk)
    );

    // === PART 2: Write controller ===
    // Increment write pointer if winc and FIFO not full
    assign wbin_next = wbin + ((winc && (~wfull)) ? 1'b1 : 1'b0);
    assign wgray_next = bin2gray(wbin_next);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wgray <= 0;
        end else begin
            wbin <= wbin_next;
            wgray <= wgray_next;
        end
    end

    // === PART 3: Read controller ===
    // Increment read pointer if rinc and FIFO not empty
    assign rbin_next = rbin + ((rinc && (~rempty)) ? 1'b1 : 1'b0);
    assign rgray_next = bin2gray(rbin_next);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rgray <= 0;
        end else begin
            rbin <= rbin_next;
            rgray <= rgray_next;
        end
    end

    // === PART 1: Dual-port RAM ===
    // Addresses are lower ADDR_WIDTH bits of binary pointers converted from gray code
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // Write enable only when winc and not full
    wire wen = winc && ~wfull;
    // Read enable only when rinc and not empty
    wire ren = rinc && ~rempty;

    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Register the output data on rclk domain after read enable
    reg [WIDTH-1:0] rdata_reg = {WIDTH{1'b0}};
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (ren)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

    // === PART 2: Full detection in write clock domain ===
    // FIFO is full if next wgray is equal to rgray_sync with inverted two MSB bits, rest same
    wire full_flag;

    assign full_flag = (wgray_next[ADDR_WIDTH]     != rgray_sync_wclk[ADDR_WIDTH])   &&
                       (wgray_next[ADDR_WIDTH-1]   != rgray_sync_wclk[ADDR_WIDTH-1]) &&
                       (wgray_next[ADDR_WIDTH-2:0] == rgray_sync_wclk[ADDR_WIDTH-2:0]);

    assign wfull = full_flag;

    // === PART 3: Empty detection in read clock domain ===
    // FIFO is empty if read pointer equals synchronized write pointer
    assign rempty = (rgray == wgray_sync_rclk);

    // -------------------------------------------------------------------
    // Gray code conversion function
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin);
        integer i;
        begin
            bin2gray[ADDR_WIDTH] = bin[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

endmodule


// -----------------------------------------------------
// Pointer Synchronizer module: two-stage synchronizer for Gray code pointer crossing clock domains
module sync_gray #(
    parameter WIDTH = 5
)(
    input                 dest_clk,
    input                 dest_rstn,
    input  [WIDTH-1:0]    async_ptr,
    output reg [WIDTH-1:0] sync_ptr = 0
);

    reg [WIDTH-1:0] sync_ff1 = 0;

    always @(posedge dest_clk or negedge dest_rstn) begin
        if (!dest_rstn) begin
            sync_ff1 <= 0;
            sync_ptr <= 0;
        end else begin
            sync_ff1 <= async_ptr;
            sync_ptr <= sync_ff1;
        end
    end

endmodule


// -----------------------------------------------------
// Dual-Port RAM module with asynchronous clocks on ports
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]          wdata,
    input                       rclk,
    input                       renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);

    // RAM storage
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write port process
    always @(posedge wclk) begin
        if (wenc)
            ram_mem[waddr] <= wdata;
    end

    // Read port process
    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule