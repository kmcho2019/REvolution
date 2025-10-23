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
    localparam PTR_EXT = PTR_WIDTH + 1;

    // Binary pointers
    reg [PTR_EXT-1:0] wptr_bin;
    reg [PTR_EXT-1:0] rptr_bin;

    // Gray pointers
    wire [PTR_EXT-1:0] wptr_gray;
    wire [PTR_EXT-1:0] rptr_gray;

    // Synchronizer outputs for cross clock domain pointers
    wire [PTR_EXT-1:0] rptr_gray_sync; // rptr synchronized to wclk domain
    wire [PTR_EXT-1:0] wptr_gray_sync; // wptr synchronized to rclk domain

    // Write enable and read enable gated by full/empty
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Function: Binary to Gray code
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Function: Gray code to Binary
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin;
        begin
            bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for(i = PTR_EXT-2; i >= 0; i=i-1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // Write pointer binary increment logic and gray conversion
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (w_en) begin
            wptr_bin <= wptr_bin + 1'b1;
        end
    end
    assign wptr_gray = bin2gray(wptr_bin);

    // Read pointer binary increment logic and gray conversion
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (r_en) begin
            rptr_bin <= rptr_bin + 1'b1;
        end
    end
    assign rptr_gray = bin2gray(rptr_bin);

    // Synchronize read pointer gray into write clock domain
    ptr_sync #(
        .WIDTH(PTR_EXT)
    ) read_ptr_sync (
        .clk(wclk),
        .rst_n(wrstn),
        .in_ptr(rptr_gray),
        .out_ptr(rptr_gray_sync)
    );

    // Synchronize write pointer gray into read clock domain
    ptr_sync #(
        .WIDTH(PTR_EXT)
    ) write_ptr_sync (
        .clk(rclk),
        .rst_n(rrstn),
        .in_ptr(wptr_gray),
        .out_ptr(wptr_gray_sync)
    );

    // Convert synchronized gray pointers back to binary for RAM addressing
    wire [PTR_EXT-1:0] rptr_bin_sync = gray2bin(rptr_gray_sync);
    wire [PTR_EXT-1:0] wptr_bin_sync = gray2bin(wptr_gray_sync);

    // Addresses for RAM (lowest PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Full when write pointer equals read pointer with top two bits inverted
    assign wfull = (wptr_gray == {~rptr_gray_sync[PTR_EXT-1:PTR_EXT-2], rptr_gray_sync[PTR_EXT-3:0]});
    // Empty when pointers are equal
    assign rempty = (rptr_gray == wptr_gray_sync);

    // Update read data register on read clock domain when read enable
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM submodule
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

// 2-stage pointer synchronizer module
module ptr_sync #(
    parameter WIDTH = 5
)(
    input                  clk,
    input                  rst_n,
    input  [WIDTH-1:0]     in_ptr,
    output reg [WIDTH-1:0] out_ptr
);
    reg [WIDTH-1:0] sync_reg1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_reg1 <= 0;
            out_ptr <= 0;
        end else begin
            sync_reg1 <= in_ptr;
            out_ptr <= sync_reg1;
        end
    end
endmodule


module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                         wclk,
    input                         wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]        wdata,
    input                         rclk,
    input                         renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]        rdata
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end
endmodule