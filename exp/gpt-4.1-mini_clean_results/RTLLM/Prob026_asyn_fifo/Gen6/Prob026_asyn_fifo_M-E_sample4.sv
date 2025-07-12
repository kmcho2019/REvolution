`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,
    input                 rrstn,
    input                 winc,
    input                 rinc,
    input  [WIDTH-1:0]    wdata,
    output                wfull,
    output                rempty,
    output reg [WIDTH-1:0] rdata
);

    // Calculate address and pointer widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // One extra bit for full detection

    // Gray code pointer registers
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Binary pointers for RAM addressing (derived from Gray)
    wire [PTR_WIDTH-1:0] wptr_bin = gray2bin(wptr_gray);
    wire [PTR_WIDTH-1:0] rptr_bin = gray2bin(rptr_gray);

    // Synchronizers for crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_ff1, rptr_gray_wclk_ff2;
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_ff1, wptr_gray_rclk_ff2;

    // Write domain: synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_ff1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_wclk_ff2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_ff1 <= rptr_gray;
            rptr_gray_wclk_ff2 <= rptr_gray_wclk_ff1;
        end
    end

    // Read domain: synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_ff1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_rclk_ff2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_ff1 <= wptr_gray;
            wptr_gray_rclk_ff2 <= wptr_gray_rclk_ff1;
        end
    end

    // Gray code increment function
    function [PTR_WIDTH-1:0] gray_increment(input [PTR_WIDTH-1:0] gray_in);
        reg [PTR_WIDTH-1:0] bin;
        reg [PTR_WIDTH-1:0] bin_plus1;
        begin
            bin = gray2bin(gray_in);
            bin_plus1 = bin + 1'b1;
            gray_increment = bin2gray(bin_plus1);
        end
    endfunction

    // Write pointer logic (wclk domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (winc && ~wfull) begin
            wptr_gray <= gray_increment(wptr_gray);
        end
    end

    // Read pointer logic (rclk domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else if (rinc && ~rempty) begin
            rptr_gray <= gray_increment(rptr_gray);
        end
    end

    // Convert synchronized pointers to binary for comparison and RAM addressing
    wire [PTR_WIDTH-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk_ff2);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk_ff2);

    // Calculate full flag:
    // FIFO is full if the next write pointer equals read pointer with MSB and next MSB inverted (standard asynchronous FIFO full condition)
    wire [PTR_WIDTH-1:0] wptr_gray_next = gray_increment(wptr_gray);
    assign wfull = (wptr_gray_next[PTR_WIDTH-3:0] == rptr_gray_wclk_ff2[PTR_WIDTH-3:0]) &&
                   (wptr_gray_next[PTR_WIDTH-1] != rptr_gray_wclk_ff2[PTR_WIDTH-1]) &&
                   (wptr_gray_next[PTR_WIDTH-2] != rptr_gray_wclk_ff2[PTR_WIDTH-2]);

    // Calculate empty flag: FIFO is empty if read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_ff2);

    // RAM addresses from lower ADDR_WIDTH bits of pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Enable signals for RAM
    wire wren = winc & ~wfull;
    wire rden = rinc & ~rempty;

    // RAM read data
    wire [WIDTH-1:0] ram_rdata;

    // Register rdata at read clock domain when read enable asserted
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (rden)
            rdata <= ram_rdata;
    end

    // Instantiate the dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wren),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rden),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Function to convert Gray code to binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH - 2; i >= 0; i = i - 1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // Function to convert binary to Gray code
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        reg [PTR_WIDTH-1:0] gray;
        begin
            gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH - 2; i >= 0; i = i - 1)
                gray[i] = bin[i+1] ^ bin[i];
            bin2gray = gray;
        end
    endfunction

endmodule

// Dual-port RAM module with synchronous write and read ports
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]         wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write logic
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read logic
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule