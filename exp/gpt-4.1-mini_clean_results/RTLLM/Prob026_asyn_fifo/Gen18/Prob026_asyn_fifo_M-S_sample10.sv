`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,    // active low write reset
    input                 rrstn,    // active low read reset
    input                 winc,     // write increment pulse
    input                 rinc,     // read increment pulse
    input  [WIDTH-1:0]    wdata,    // write data input
    output                wfull,    // FIFO full flag (write clock domain)
    output                rempty,   // FIFO empty flag (read clock domain)
    output reg [WIDTH-1:0] rdata    // read data output
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    // Write pointer (Gray code)
    reg [PTR_WIDTH:0] wptr_gray;
    // Read pointer (Gray code)
    reg [PTR_WIDTH:0] rptr_gray;

    // Pointer increments in binary
    wire [PTR_WIDTH:0] wbin = gray2bin(wptr_gray);
    wire [PTR_WIDTH:0] rbin = gray2bin(rptr_gray);

    // Write pointer next binary and Gray
    wire [PTR_WIDTH:0] wbin_next = wbin + (winc & ~wfull);
    wire [PTR_WIDTH:0] wptr_gray_next = bin2gray(wbin_next);

    // Read pointer next binary and Gray
    wire [PTR_WIDTH:0] rbin_next = rbin + (rinc & ~rempty);
    wire [PTR_WIDTH:0] rptr_gray_next = bin2gray(rbin_next);

    // Synchronizers (2-stage flip flop) for pointer crossing
    wire [PTR_WIDTH:0] rptr_gray_sync_wclk;
    wire [PTR_WIDTH:0] wptr_gray_sync_rclk;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_gray <= 0;
        else
            wptr_gray <= wptr_gray_next;
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_gray <= 0;
        else
            rptr_gray <= rptr_gray_next;
    end

    // Synchronize read pointer into write clock domain
    gray_sync #(.WIDTH(PTR_WIDTH+1)) rptr_sync_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .din(rptr_gray),
        .dout(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer into read clock domain
    gray_sync #(.WIDTH(PTR_WIDTH+1)) wptr_sync_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .din(wptr_gray),
        .dout(wptr_gray_sync_rclk)
    );

    // FIFO full condition (in write clock domain)
    // Full when next wptr equals read pointer with top two bits inverted
    assign wfull = (wptr_gray_next[PTR_WIDTH]     != rptr_gray_sync_wclk[PTR_WIDTH]) &&
                   (wptr_gray_next[PTR_WIDTH-1]   != rptr_gray_sync_wclk[PTR_WIDTH-1]) &&
                   (wptr_gray_next[PTR_WIDTH-2:0] == rptr_gray_sync_wclk[PTR_WIDTH-2:0]);

    // FIFO empty condition (in read clock domain)
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // RAM addresses for write and read (use lower PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr = wbin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rbin[PTR_WIDTH-1:0];

    // Write enable and read enable signals
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    wire [WIDTH-1:0] ram_rdata;

    // Register read data output
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM
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

    // Gray code to binary conversion function
    function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Binary to Gray code conversion function
    function [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH] = bin[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

endmodule


// Two-stage synchronizer for Gray-coded pointers crossing clock domains
module gray_sync #(
    parameter WIDTH = 5
)(
    input                 clk,
    input                 rst_n,
    input  [WIDTH-1:0]    din,
    output reg [WIDTH-1:0] dout
);

    reg [WIDTH-1:0] sync_ff;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff <= 0;
            dout <= 0;
        end else begin
            sync_ff <= din;
            dout <= sync_ff;
        end
    end

endmodule


// Dual-port RAM with separate clocks and enables
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

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
        else
            rdata <= rdata; // hold previous data when not reading
    end

endmodule