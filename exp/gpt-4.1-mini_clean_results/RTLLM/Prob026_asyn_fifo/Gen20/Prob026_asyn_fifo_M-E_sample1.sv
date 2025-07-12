`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,   // active low reset for write domain
    input                 rrstn,   // active low reset for read domain
    input                 winc,    // write enable (push)
    input                 rinc,    // read enable (pop)
    input  [WIDTH-1:0]    wdata,   // data input
    output                wfull,   // full flag (write domain)
    output                rempty,  // empty flag (read domain)
    output [WIDTH-1:0]    rdata    // data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Pointer widths include 1 extra MSB for wrap-around
    reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;      // binary pointers
    reg [ADDR_WIDTH:0] wptr_gray, rptr_gray;    // Gray-coded pointers

    // Synchronized pointers crossing clock domains
    reg [ADDR_WIDTH:0] rptr_gray_wclk_sync1, rptr_gray_wclk_sync2;
    reg [ADDR_WIDTH:0] wptr_gray_rclk_sync1, wptr_gray_rclk_sync2;

    // Next pointers
    reg [ADDR_WIDTH:0] wptr_bin_next, wptr_gray_next;
    reg [ADDR_WIDTH:0] rptr_bin_next, rptr_gray_next;

    // RAM addresses (lower bits of binary pointers)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable for RAM
    wire wen = winc & ~wfull;
    // Read enable for RAM
    wire ren = rinc & ~rempty;

    wire [WIDTH-1:0] ram_rdata;

    // =================================================================
    // Part 1: Dual-Port RAM instantiation
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

    // =================================================================
    // Part 2: Write pointer logic (write clock domain)

    // Gray code conversion function
    function [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] bin_in);
        integer i;
        begin
            bin2gray[ADDR_WIDTH] = bin_in[ADDR_WIDTH];
            for (i=ADDR_WIDTH-1; i>=0; i=i-1) begin
                bin2gray[i] = bin_in[i+1] ^ bin_in[i];
            end
        end
    endfunction

    // Binary conversion from Gray code (for internal use)
    function [ADDR_WIDTH:0] gray2bin(input [ADDR_WIDTH:0] gray_in);
        integer i;
        begin
            gray2bin[ADDR_WIDTH] = gray_in[ADDR_WIDTH];
            for (i=ADDR_WIDTH-1; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray_in[i];
            end
        end
    endfunction

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= { (ADDR_WIDTH+1){1'b0} };
            wptr_gray <= { (ADDR_WIDTH+1){1'b0} };
        end else begin
            if (wen) begin
                wptr_bin_next = wptr_bin + 1'b1;
                wptr_bin <= wptr_bin_next;
                wptr_gray_next = bin2gray(wptr_bin_next);
                wptr_gray <= wptr_gray_next;
            end else begin
                wptr_bin_next = wptr_bin;
                wptr_gray_next = wptr_gray;
            end
        end
    end

    // =================================================================
    // Part 3: Read pointer logic (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= { (ADDR_WIDTH+1){1'b0} };
            rptr_gray <= { (ADDR_WIDTH+1){1'b0} };
        end else begin
            if (ren) begin
                rptr_bin_next = rptr_bin + 1'b1;
                rptr_bin <= rptr_bin_next;
                rptr_gray_next = bin2gray(rptr_bin_next);
                rptr_gray <= rptr_gray_next;
            end else begin
                rptr_bin_next = rptr_bin;
                rptr_gray_next = rptr_gray;
            end
        end
    end

    // =================================================================
    // Part 4: Read pointer synchronizer (read pointer gray sync to write clk)
    // Two flip-flop synchronizer (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync1 <= 0;
            rptr_gray_wclk_sync2 <= 0;
        end else begin
            rptr_gray_wclk_sync1 <= rptr_gray;
            rptr_gray_wclk_sync2 <= rptr_gray_wclk_sync1;
        end
    end

    // =================================================================
    // Part 5: Write pointer synchronizer (write pointer gray sync to read clk)
    // Two flip-flop synchronizer (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync1 <= 0;
            wptr_gray_rclk_sync2 <= 0;
        end else begin
            wptr_gray_rclk_sync1 <= wptr_gray;
            wptr_gray_rclk_sync2 <= wptr_gray_rclk_sync1;
        end
    end

    // =================================================================
    // Part 6: Full detection (write clock domain)

    // FIFO is full if write pointer next equals read pointer synchronized to write clock
    // with two MSBs inverted and rest equal
    wire full_condition;
    wire [ADDR_WIDTH:0] wptr_gray_next_dup = wptr_gray_next;

    assign full_condition = 
        (wptr_gray_next_dup[ADDR_WIDTH]     != rptr_gray_wclk_sync2[ADDR_WIDTH])     &&
        (wptr_gray_next_dup[ADDR_WIDTH-1]   != rptr_gray_wclk_sync2[ADDR_WIDTH-1])   &&
        (wptr_gray_next_dup[ADDR_WIDTH-2:0] == rptr_gray_wclk_sync2[ADDR_WIDTH-2:0]);

    assign wfull = full_condition;

    // =================================================================
    // Part 7: Empty detection (read clock domain)

    // FIFO is empty if read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_sync2);

    // =================================================================
    // Part 8: Output data register (read clock domain)
    reg [WIDTH-1:0] rdata_reg;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (ren)
            rdata_reg <= ram_rdata;
    end

    assign rdata = rdata_reg;

endmodule

// =======================================================================
// Dual-port RAM submodule

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