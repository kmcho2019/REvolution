`timescale 1ns/1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,    // Write clock
    input                  rclk,    // Read clock
    input                  wrstn,   // Write domain async reset (active low)
    input                  rrstn,   // Read domain async reset (active low)
    input                  winc,    // Write increment (push)
    input                  rinc,    // Read increment (pop)
    input      [WIDTH-1:0] wdata,   // Write data input
    output                 wfull,   // Write full flag
    output                 rempty,  // Read empty flag
    output reg [WIDTH-1:0] rdata    // Read data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // One extra bit for full/empty detection

    // -------------------------------------------------------
    // Write pointer binary and Gray-coded
    // Increment on wclk with wrstn reset
    // -------------------------------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    wire wpush = winc & ~wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (wpush) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= (wptr_bin + 1'b1) ^ ((wptr_bin + 1'b1) >> 1);
        end
    end

    // -------------------------------------------------------
    // Read pointer binary and Gray-coded
    // Increment on rclk with rrstn reset
    // -------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    wire rpop = rinc & ~rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (rpop) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= (rptr_bin + 1'b1) ^ ((rptr_bin + 1'b1) >> 1);
        end
    end

    // -------------------------------------------------------
    // Synchronize Gray-coded pointers crossing clock domains
    // Two-stage synchronizers for metastability mitigation
    // -------------------------------------------------------

    // Synchronize read pointer Gray code into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_w, rptr_gray_sync2_w;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_w <= 0;
            rptr_gray_sync2_w <= 0;
        end else begin
            rptr_gray_sync1_w <= rptr_gray;
            rptr_gray_sync2_w <= rptr_gray_sync1_w;
        end
    end

    // Synchronize write pointer Gray code into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_r, wptr_gray_sync2_r;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_r <= 0;
            wptr_gray_sync2_r <= 0;
        end else begin
            wptr_gray_sync1_r <= wptr_gray;
            wptr_gray_sync2_r <= wptr_gray_sync1_r;
        end
    end

    // -------------------------------------------------------
    // Convert synchronized Gray codes to binary for full/empty detection
    // Gray to binary function
    // -------------------------------------------------------
    function [PTR_WIDTH-1:0] gray_to_bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray_to_bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i=i-1)
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
        end
    endfunction

    // Synchronized pointers in binary domain
    wire [PTR_WIDTH-1:0] rptr_bin_sync_w = gray_to_bin(rptr_gray_sync2_w);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_r = gray_to_bin(wptr_gray_sync2_r);

    // -------------------------------------------------------
    // Empty condition (read domain): when read pointer equals synchronized write pointer
    // -------------------------------------------------------
    assign rempty = (rptr_gray == wptr_gray_sync2_r);

    // -------------------------------------------------------
    // Full condition (write domain):
    // FIFO is full when the next write pointer equals read pointer with MSB and next MSB inverted
    // According to standard FIFO full condition in Gray code domain:
    // wfull = (wptr_gray == {~rptr_gray_sync2_w[PTR_WIDTH-1], ~rptr_gray_sync2_w[PTR_WIDTH-2], rptr_gray_sync2_w[PTR_WIDTH-3:0]})
    // -------------------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_gray_inv = {
        ~rptr_gray_sync2_w[PTR_WIDTH-1],
        ~rptr_gray_sync2_w[PTR_WIDTH-2],
        rptr_gray_sync2_w[PTR_WIDTH-3:0]
    };

    assign wfull = (wptr_gray == rptr_gray_inv);

    // -------------------------------------------------------
    // RAM addressing: use lower ADDR_WIDTH bits of binary pointers
    // -------------------------------------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire wram_en = wpush;
    wire rram_en = rpop;

    wire [WIDTH-1:0] ram_rdata;

    // -------------------------------------------------------
    // Instantiate dual-port RAM module
    // -------------------------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wram_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rram_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // -------------------------------------------------------
    // Register the output data on rclk domain when pop happens
    // -------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rpop)
            rdata <= ram_rdata;
    end

endmodule


// ---------------------------------------------------------------------------------------
// Dual-port RAM behavioral model with separate read/write clocks
// ---------------------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wire                    wclk,
    input  wire                    wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]        wdata,
    input  wire                    rclk,
    input  wire                    renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]        rdata
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