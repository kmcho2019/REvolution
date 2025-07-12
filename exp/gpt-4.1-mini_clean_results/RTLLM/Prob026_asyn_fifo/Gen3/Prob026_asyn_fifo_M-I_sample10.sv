`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                  wclk,
    input  wire                  wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,

    input  wire                  rclk,
    input  wire                  renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
);
    // Memory declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port - synchronous read with output register
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end
endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1  // One extra bit for full detection
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,
    input  wire                 rrstn,
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output reg                  wfull,
    output reg                  rempty,
    output wire [WIDTH-1:0]     rdata
);

    // Function: Binary to Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Function: Gray code to binary conversion
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write and read binary pointers
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Write and read Gray pointers
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronizers for crossing domains (two-stage flip-flop synchronizers)
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2; // read pointer synchronized to write clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2; // write pointer synchronized to read clock domain

    // Write enable signal (only write if FIFO not full)
    wire wen = winc & ~wfull;

    // Read enable signal (only read if FIFO not empty)
    wire ren = rinc & ~rempty;

    // Synchronize read pointer into write clock domain
    always @(posedge wclk) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Write pointer logic
    always @(posedge wclk) begin
        if (!wrstn) begin
            wptr_bin  <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (wen) begin
            wptr_bin  <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
        end
    end

    // Read pointer logic
    always @(posedge rclk) begin
        if (!rrstn) begin
            rptr_bin  <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (ren) begin
            rptr_bin  <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
        end
    end

    // Addresses to RAM are lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
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

    // Full detection:
    // Condition: wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_sync2[PTR_WIDTH-3:0]}
    // That is, MSB and MSB-1 bits inverted, remaining bits equal
    wire [PTR_WIDTH-1:0] rptr_gray_inv = {~rptr_gray_sync2[PTR_WIDTH-1], ~rptr_gray_sync2[PTR_WIDTH-2], rptr_gray_sync2[PTR_WIDTH-3:0]};

    always @(posedge wclk) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= (wptr_gray == rptr_gray_inv);
    end

    // Empty detection: when read pointer equals synchronized write pointer
    always @(posedge rclk) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= (rptr_gray == wptr_gray_sync2);
    end

endmodule