`timescale 1ns/1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,  // active low reset for write domain
    input                   rrstn,  // active low reset for read domain
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // extra bit for full/empty distinction

    // Write domain binary and Gray pointers
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);

    // Read domain binary and Gray pointers
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronizers for crossing domains
    // Synchronize read pointer (Gray) into write clock domain
    wire [PTR_WIDTH-1:0] rptr_gray_sync_w;
    pointer_sync #(.WIDTH(PTR_WIDTH)) rptr_sync_inst (
        .clk(wclk),
        .arst_n(wrstn),
        .in_ptr(rptr_gray),
        .out_ptr(rptr_gray_sync_w)
    );

    // Synchronize write pointer (Gray) into read clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_sync_r;
    pointer_sync #(.WIDTH(PTR_WIDTH)) wptr_sync_inst (
        .clk(rclk),
        .arst_n(rrstn),
        .in_ptr(wptr_gray),
        .out_ptr(wptr_gray_sync_r)
    );

    // Convert synchronized pointers back to binary for address and comparison
    wire [PTR_WIDTH-1:0] rptr_bin_sync_w = gray2bin(rptr_gray_sync_w);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_r = gray2bin(wptr_gray_sync_r);

    // Write pointer increment logic (in write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer increment logic (in read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Addresses into RAM are lower ADDR_WIDTH bits of pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write and read enables for RAM
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Full condition: write pointer equals read pointer with top two bits inverted
    assign wfull = (wptr_gray == {~rptr_gray_sync_w[PTR_WIDTH-1], ~rptr_gray_sync_w[PTR_WIDTH-2], rptr_gray_sync_w[PTR_WIDTH-3:0]});

    // Empty condition: read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync_r);

    // Instantiate dual-port RAM
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
        .rdata(rdata)
    );

    // Gray code conversion functions
    function automatic [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function automatic [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

endmodule


// Dual-port RAM module with separate clocks
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]      wdata,
    input                       rclk,
    input                       renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: synchronous write on write clock
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;  // blocking assignment for write to mimic inferred RAM behavior
    end

    // Read port: synchronous read on read clock
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];  // registered read data output
    end

endmodule


// 2-stage pointer synchronizer module for crossing clock domains
module pointer_sync #(
    parameter WIDTH = 5
)(
    input                   clk,
    input                   arst_n,
    input  [WIDTH-1:0]      in_ptr,
    output reg [WIDTH-1:0]  out_ptr
);

    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge arst_n) begin
        if (!arst_n) begin
            sync_stage1 <= {WIDTH{1'b0}};
            out_ptr    <= {WIDTH{1'b0}};
        end else begin
            sync_stage1 <= in_ptr;
            out_ptr    <= sync_stage1;
        end
    end

endmodule