`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input               wclk,
    input               rclk,
    input               wrstn,    // write domain async reset, active low
    input               rrstn,    // read domain async reset, active low
    input               winc,     // write enable (write increment)
    input               rinc,     // read enable (read increment)
    input  [WIDTH-1:0]  wdata,    // write data input
    output              wfull,    // FIFO full indication
    output              rempty,   // FIFO empty indication
    output [WIDTH-1:0]  rdata     // read data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Part 1: dual-port RAM (implemented below)
    // Write port uses wclk, waddr
    // Read port uses rclk, raddr

    // Part 2: Write Controller (write pointer + full detection)
    wire [ADDR_WIDTH:0] wptr_bin_next;
    wire [ADDR_WIDTH:0] wptr_bin;
    wire [ADDR_WIDTH:0] wptr_gray;
    wire wfull_int;

    // Part 3: Read Controller (read pointer + empty detection)
    wire [ADDR_WIDTH:0] rptr_bin_next;
    wire [ADDR_WIDTH:0] rptr_bin;
    wire [ADDR_WIDTH:0] rptr_gray;
    wire rempty_int;

    // Part 4: Read pointer synchronizer (sync read pointer into write clock domain)
    wire [ADDR_WIDTH:0] rptr_gray_sync_to_wclk;

    // Part 5: Write pointer synchronizer (sync write pointer into read clock domain)
    wire [ADDR_WIDTH:0] wptr_gray_sync_to_rclk;

    // Write Controller Module
    write_controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) write_ctrl (
        .wclk(wclk),
        .wrstn(wrstn),
        .winc(winc),
        .rptr_gray_sync(rptr_gray_sync_to_wclk),
        .wfull(wfull_int),
        .wptr_bin(wptr_bin),
        .wptr_gray(wptr_gray)
    );

    // Read Controller Module
    read_controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) read_ctrl (
        .rclk(rclk),
        .rrstn(rrstn),
        .rinc(rinc),
        .wptr_gray_sync(wptr_gray_sync_to_rclk),
        .rempty(rempty_int),
        .rptr_bin(rptr_bin),
        .rptr_gray(rptr_gray)
    );

    // Read Pointer Synchronizer (rptr_gray sync to wclk domain)
    pointer_synchronizer #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) rptr_sync (
        .clk(wclk),
        .arstn(wrstn),
        .async_ptr(rptr_gray),
        .sync_ptr(rptr_gray_sync_to_wclk)
    );

    // Write Pointer Synchronizer (wptr_gray sync to rclk domain)
    pointer_synchronizer #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) wptr_sync (
        .clk(rclk),
        .arstn(rrstn),
        .async_ptr(wptr_gray),
        .sync_ptr(wptr_gray_sync_to_rclk)
    );

    // Convert Gray pointers to binary addresses for RAM ports (lower ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = gray_to_bin(wptr_gray)[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = gray_to_bin(rptr_gray)[ADDR_WIDTH-1:0];

    // Generate read enable gated by not empty
    wire ren = rinc & ~rempty_int;
    // Generate write enable gated by not full
    wire wen = winc & ~wfull_int;

    // RAM read data output
    wire [WIDTH-1:0] ram_rdata;

    // Read Data Register
    reg [WIDTH-1:0] rdata_reg = {WIDTH{1'b0}};
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (ren)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Output full and empty signals
    assign wfull = wfull_int;
    assign rempty = rempty_int;


    // Function: gray to binary conversion for (ADDR_WIDTH+1) bits
    function [ADDR_WIDTH:0] gray_to_bin(input [ADDR_WIDTH:0] gray);
        integer i;
        begin
            gray_to_bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1) begin
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
            end
        end
    endfunction

endmodule

// --------------------------------------------------------------------------------------
// Write Controller Module: manages write pointer and full detection (in write clock domain)
module write_controller #(
    parameter ADDR_WIDTH = 4
)(
    input                    wclk,
    input                    wrstn,
    input                    winc,               // write increment request
    input  [ADDR_WIDTH:0]    rptr_gray_sync,     // synchronized read pointer (Gray code) from read domain
    output                   wfull,              // full flag output
    output reg [ADDR_WIDTH:0] wptr_bin = 0,      // current write pointer (binary)
    output reg [ADDR_WIDTH:0] wptr_gray = 0      // current write pointer (Gray code)
);
    // Calculate next pointer on write enable and if not full
    wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + (winc & ~wfull ? 1'b1 : 1'b0);
    wire [ADDR_WIDTH:0] wptr_gray_next = bin_to_gray(wptr_bin_next);

    // Update pointers on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Full condition detection
    // FIFO is full when:
    // next write pointer Gray code equals read pointer Gray code with top two bits inverted and others equal
    // Meaning:
    // wptr_gray_next[ADDR_WIDTH]    != rptr_gray_sync[ADDR_WIDTH]
    // wptr_gray_next[ADDR_WIDTH-1]  != rptr_gray_sync[ADDR_WIDTH-1]
    // wptr_gray_next[ADDR_WIDTH-2:0] == rptr_gray_sync[ADDR_WIDTH-2:0]

    wire msb_eq_inv = (wptr_gray_next[ADDR_WIDTH]     != rptr_gray_sync[ADDR_WIDTH]);
    wire msb1_eq_inv = (wptr_gray_next[ADDR_WIDTH-1]  != rptr_gray_sync[ADDR_WIDTH-1]);
    wire lower_eq    = (wptr_gray_next[ADDR_WIDTH-2:0] == rptr_gray_sync[ADDR_WIDTH-2:0]);

    assign wfull = msb_eq_inv & msb1_eq_inv & lower_eq;

    // Binary to Gray function for (ADDR_WIDTH+1) bits
    function [ADDR_WIDTH:0] bin_to_gray(input [ADDR_WIDTH:0] bin);
        integer i;
        begin
            bin_to_gray[ADDR_WIDTH] = bin[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1) begin
                bin_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

endmodule


// --------------------------------------------------------------------------------------
// Read Controller Module: manages read pointer and empty detection (in read clock domain)
module read_controller #(
    parameter ADDR_WIDTH = 4
)(
    input                    rclk,
    input                    rrstn,
    input                    rinc,               // read increment request
    input  [ADDR_WIDTH:0]    wptr_gray_sync,     // synchronized write pointer (Gray code) from write domain
    output                   rempty,             // empty flag output
    output reg [ADDR_WIDTH:0] rptr_bin = 0,      // current read pointer (binary)
    output reg [ADDR_WIDTH:0] rptr_gray = 0      // current read pointer (Gray code)
);

    wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + (rinc & ~rempty ? 1'b1 : 1'b0);
    wire [ADDR_WIDTH:0] rptr_gray_next = bin_to_gray(rptr_bin_next);

    // Update pointers on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Empty condition detection
    // FIFO is empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync);

    // Binary to Gray function for (ADDR_WIDTH+1) bits
    function [ADDR_WIDTH:0] bin_to_gray(input [ADDR_WIDTH:0] bin);
        integer i;
        begin
            bin_to_gray[ADDR_WIDTH] = bin[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1) begin
                bin_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

endmodule


// --------------------------------------------------------------------------------------
// Pointer Synchronizer: two-stage synchronizer for Gray coded pointer crossing clock domains
module pointer_synchronizer #(
    parameter ADDR_WIDTH = 4
)(
    input                   clk,
    input                   arstn,
    input  [ADDR_WIDTH:0]   async_ptr,
    output reg [ADDR_WIDTH:0] sync_ptr = 0
);

    reg [ADDR_WIDTH:0] sync_ff1 = 0;

    always @(posedge clk or negedge arstn) begin
        if (!arstn) begin
            sync_ff1 <= 0;
            sync_ptr <= 0;
        end else begin
            sync_ff1 <= async_ptr;
            sync_ptr <= sync_ff1;
        end
    end

endmodule


// --------------------------------------------------------------------------------------
// Dual-Port RAM implementation with separate clocks and enables
// Write port: wclk, waddr, wdata, wenc
// Read port: rclk, raddr, renc, rdata
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
    // Declare RAM array
    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write process (write enabled on wclk rising edge)
    always @(posedge wclk) begin
        if (wenc) begin
            ram_mem[waddr] <= wdata;
        end
    end

    // Read process (read enabled on rclk rising edge)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= ram_mem[raddr];
        end
    end

endmodule