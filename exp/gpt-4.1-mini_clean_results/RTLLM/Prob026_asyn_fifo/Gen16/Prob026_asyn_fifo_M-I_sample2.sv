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

    // Calculate address width and pointer width
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // Extra bit for full/empty distinction

    // Binary pointers in respective clock domains
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray coded pointers
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronize pointers across clock domains
    wire [PTR_WIDTH-1:0] rptr_gray_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_rclk;

    // Two-stage synchronizers for Gray pointers
    asyn_fifo_gray_sync #(.WIDTH(PTR_WIDTH)) rptr_sync_inst (
        .clk(wclk),
        .rstn(wrstn),
        .in_gray(rptr_gray),
        .out_gray(rptr_gray_wclk)
    );

    asyn_fifo_gray_sync #(.WIDTH(PTR_WIDTH)) wptr_sync_inst (
        .clk(rclk),
        .rstn(rrstn),
        .in_gray(wptr_gray),
        .out_gray(wptr_gray_rclk)
    );

    // Convert synchronized Gray pointers to binary
    wire [PTR_WIDTH-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk);

    // Write pointer increment and reset
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer increment and reset
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Write and read addresses for RAM: lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable for RAM
    wire wen = winc && !wfull;

    // Full detection function comparing Gray-coded pointers:
    // FIFO is full when write pointer is one ahead of read pointer,
    // considering the top two bits inversion and others same.
    function full_flag;
        input [PTR_WIDTH-1:0] wptr;
        input [PTR_WIDTH-1:0] rptr_sync;
        begin
            // Full condition:
            // wptr[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2]
            // and wptr[PTR_WIDTH-3:0] == rptr_sync[PTR_WIDTH-3:0]
            full_flag = ( (wptr[PTR_WIDTH-1] != rptr_sync[PTR_WIDTH-1]) &&
                          (wptr[PTR_WIDTH-2] != rptr_sync[PTR_WIDTH-2]) &&
                          (wptr[PTR_WIDTH-3:0] == rptr_sync[PTR_WIDTH-3:0]) );
        end
    endfunction

    assign wfull = full_flag(wptr_gray, rptr_gray_wclk);

    // Empty detection - FIFO is empty when read and write pointers match (Gray code)
    assign rempty = (rptr_gray == wptr_gray_rclk);

    // Instantiate dual-port RAM
    wire [WIDTH-1:0] ram_rdata;
    asyn_fifo_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    assign rdata = ram_rdata;

    // Gray code conversion: binary to Gray
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Gray code conversion: Gray to binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

endmodule


// Dual-port RAM with synchronous read and write
module asyn_fifo_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                         wclk,
    input                         wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]        wdata,
    input                         rclk,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]        rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port - synchronous write
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port - synchronous read
    always @(posedge rclk) begin
        rdata <= mem[raddr];
    end

endmodule


// Two-stage synchronizer for multi-bit Gray code vector
module asyn_fifo_gray_sync #(
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