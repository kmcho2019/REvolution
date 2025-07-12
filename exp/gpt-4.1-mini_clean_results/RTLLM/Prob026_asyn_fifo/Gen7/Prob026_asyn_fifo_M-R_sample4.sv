`timescale 1ns / 1ps

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
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT_WIDTH = PTR_WIDTH + 1;  // Extra MSB bit for full/empty distinction

    // Binary pointers
    reg [PTR_EXT_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_EXT_WIDTH-1:0] rptr_bin = 0;

    // Gray pointers synchronized crossing domains
    wire [PTR_EXT_WIDTH-1:0] wptr_gray;
    wire [PTR_EXT_WIDTH-1:0] rptr_gray;
    wire [PTR_EXT_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_sync_rclk;

    // Write enable gated by full signal
    wire w_en = winc & ~wfull;
    // Read enable gated by empty signal
    wire r_en = rinc & ~rempty;

    // Write and read addresses for RAM
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Continuous Gray code conversion functions
    function [PTR_EXT_WIDTH-1:0] binary_to_gray;
        input [PTR_EXT_WIDTH-1:0] bin;
        integer i;
        begin
            binary_to_gray[PTR_EXT_WIDTH-1] = bin[PTR_EXT_WIDTH-1];
            for (i=PTR_EXT_WIDTH-2; i>=0; i=i-1)
                binary_to_gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    function [PTR_EXT_WIDTH-1:0] gray_to_binary;
        input [PTR_EXT_WIDTH-1:0] gray;
        integer j;
        begin
            gray_to_binary[PTR_EXT_WIDTH-1] = gray[PTR_EXT_WIDTH-1];
            for (j=PTR_EXT_WIDTH-2; j>=0; j=j-1)
                gray_to_binary[j] = gray_to_binary[j+1] ^ gray[j];
        end
    endfunction

    // Sequential binary pointer increment (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (w_en)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Sequential binary pointer increment (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (r_en)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Combinational Gray code from binary pointers
    assign wptr_gray = binary_to_gray(wptr_bin);
    assign rptr_gray = binary_to_gray(rptr_bin);

    // Synchronizers for crossing clock domains (two-stage)
    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    synchronizer #(
        .WIDTH(PTR_EXT_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Calculate next write pointer Gray code for full detection
    wire [PTR_EXT_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_EXT_WIDTH-1:0] wptr_gray_next = binary_to_gray(wptr_bin_next);

    // Full logic - using Gray code comparison with inverted top bits
    assign wfull =
        (wptr_gray_next[PTR_EXT_WIDTH-3:0] == rptr_gray_sync_wclk[PTR_EXT_WIDTH-3:0]) &&
        (wptr_gray_next[PTR_EXT_WIDTH-1]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-1])   &&
        (wptr_gray_next[PTR_EXT_WIDTH-2]   != rptr_gray_sync_wclk[PTR_EXT_WIDTH-2]);

    // Empty logic - pointers equal in Gray code domain
    assign rempty = (rptr_gray == wptr_gray_sync_rclk);

    // Register output data on read clock domain when read enabled
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Dual-port RAM instantiation
    dual_port_RAM_async_fifo #(
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

// Two-stage synchronizer for multi-bit signal
module synchronizer #(
    parameter WIDTH = 4
)(
    input               clk,
    input               rst_n,
    input  [WIDTH-1:0]  in,
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


// Dual-port RAM module for asynchronous FIFO
module dual_port_RAM_async_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                      rclk,
    input                      renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    // RAM storage
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (synchronous write)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (synchronous read)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule