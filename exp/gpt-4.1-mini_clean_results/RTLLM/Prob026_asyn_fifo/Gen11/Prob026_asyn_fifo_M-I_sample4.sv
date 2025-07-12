`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // active low reset for write domain
    input                   rrstn,   // active low reset for read domain
    input                   winc,
    input                   rinc,
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // ----- Functions for Gray and Binary conversions -----
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // ----- Write pointer (Gray code) -----
    reg [PTR_WIDTH-1:0] wptr_gray = 0;        // write pointer Gray code
    reg [PTR_WIDTH-1:0] wptr_gray_next;
    reg [PTR_WIDTH-1:0] wptr_bin = 0;         // binary version for incrementing

    // ----- Read pointer (Gray code) -----
    reg [PTR_WIDTH-1:0] rptr_gray = 0;        // read pointer Gray code
    reg [PTR_WIDTH-1:0] rptr_gray_next;
    reg [PTR_WIDTH-1:0] rptr_bin = 0;         // binary version for incrementing

    // ----- Synchronizers -----
    // Read pointer synchronized into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync1 = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync2 = 0;
    wire [PTR_WIDTH-1:0] rptr_bin_sync;

    // Write pointer synchronized into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1 = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync2 = 0;
    wire [PTR_WIDTH-1:0] wptr_bin_sync;

    // Convert synchronized Gray pointers back to binary for comparison
    assign rptr_bin_sync = gray2bin(rptr_gray_sync2);
    assign wptr_bin_sync = gray2bin(wptr_gray_sync2);

    // Write enable and read enable conditioned by full/empty
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // ----- Write pointer increment -----
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
        end
    end

    // ----- Read pointer increment -----
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
        end
    end

    // ----- Synchronize read pointer Gray into write clock domain -----
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // ----- Synchronize write pointer Gray into read clock domain -----
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // ----- Generate full flag -----
    // FIFO full when next write pointer's binary address equals read pointer's binary address,
    // with MSB and MSB-1 bits inverted between pointers to indicate wrap-around.
    // Check using Gray code but convert to binary addresses for clarity and robustness.
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1;
    wire [ADDR_WIDTH-1:0] waddr_next = wptr_bin_next[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_sync = rptr_bin_sync[ADDR_WIDTH-1:0];

    wire msb_xor = wptr_bin_next[ADDR_WIDTH] ^ rptr_bin_sync[ADDR_WIDTH];
    wire msb_1_xor = wptr_bin_next[ADDR_WIDTH-1] ^ rptr_bin_sync[ADDR_WIDTH-1];

    assign wfull = (waddr_next == raddr_sync) && msb_xor && msb_1_xor;

    // ----- Generate empty flag -----
    assign rempty = (rptr_gray == wptr_gray_sync2);

    // ----- RAM addresses -----
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // ----- Data from RAM -----
    wire [WIDTH-1:0] ram_rdata;

    // Read data register
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // ----- Instantiate dual-port RAM -----
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


// Dual-port RAM submodule
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (write clock domain)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (read clock domain)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule