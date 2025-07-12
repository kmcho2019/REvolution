`timescale 1ns/1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    // Address and pointer widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // extra bit for full/empty distinction

    // Binary pointers (write/read)
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray pointers (write/read)
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] rptr_gray;

    // Binary to Gray conversion
    assign wptr_gray = bin2gray(wptr_bin);
    assign rptr_gray = bin2gray(rptr_bin);

    // Synchronize read pointer into write clock domain
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_rptr_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .in_gray(rptr_gray),
        .out_gray(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer into read clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_wptr_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .in_gray(wptr_gray),
        .out_gray(wptr_gray_sync_rclk)
    );

    // Convert synchronized Gray pointers back to binary for address calculation and comparison
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    // Write pointer increment logic (wclk domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer increment logic (rclk domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Extract RAM addresses from binary pointers (low ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable and read enable signals for RAM
    wire wen = (winc && !wfull);
    wire ren = (rinc && !rempty);

    // FIFO Full Detection (in write clock domain)
    // FIFO full when write pointer equals read pointer with MSB and second MSB inverted:
    // wptr_gray == {~rptr_gray_sync_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync_wclk[PTR_WIDTH-3:0]}
    assign wfull = (wptr_gray == {~rptr_gray_sync_wclk[PTR_WIDTH-1], ~rptr_gray_sync_wclk[PTR_WIDTH-2], rptr_gray_sync_wclk[PTR_WIDTH-3:0]});

    // FIFO Empty Detection (in read clock domain)
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Instantiate the dual-port RAM
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

    // ---------------------------
    // Functions for Gray code conversions
    // ---------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i -1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

endmodule


// ------------------------------------
// Dual-port RAM submodule
// Port A: Write (wclk domain)
// Port B: Read (rclk domain)
// RAM depth = DEPTH, width = WIDTH
// Asynchronous read enable (renc) is used to gate read
// ------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (wclk domain)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (rclk domain)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule


// ------------------------------------
// Gray code synchronizer
// 2-stage flip-flop synchronizer of Gray-coded vector
// ------------------------------------
module gray_sync #(
    parameter WIDTH = 5
)(
    input                   clk,
    input                   rstn,
    input  [WIDTH-1:0]      in_gray,
    output reg [WIDTH-1:0]  out_gray
);

    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= {WIDTH{1'b0}};
            out_gray <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= in_gray;
            out_gray <= sync_ff1;
        end
    end

endmodule