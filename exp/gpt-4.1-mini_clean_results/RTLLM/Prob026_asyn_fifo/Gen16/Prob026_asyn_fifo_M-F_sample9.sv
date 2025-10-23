`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,    // active low reset, write domain
    input                 rrstn,    // active low reset, read domain
    input                 winc,     // write increment request
    input                 rinc,     // read increment request
    input  [WIDTH-1:0]    wdata,    // input data to write
    output                wfull,    // FIFO full flag
    output                rempty,   // FIFO empty flag
    output reg [WIDTH-1:0] rdata    // output data read
);

    localparam PTR_WIDTH = $clog2(DEPTH);  // pointer width

    // Write domain pointers: binary and Gray code (PTR_WIDTH+1 bits)
    reg [PTR_WIDTH:0] wbin = 0;
    reg [PTR_WIDTH:0] wptr = 0;

    // Read domain pointers: binary and Gray code (PTR_WIDTH+1 bits)
    reg [PTR_WIDTH:0] rbin = 0;
    reg [PTR_WIDTH:0] rptr = 0;

    // Synchronize read pointer into write clock domain
    reg [PTR_WIDTH:0] rptr_wclk_ff1 = 0, rptr_wclk_ff2 = 0;
    // Synchronize write pointer into read clock domain
    reg [PTR_WIDTH:0] wptr_rclk_ff1 = 0, wptr_rclk_ff2 = 0;

    // Pointer increments gated by full and empty flags
    wire w_en = winc & (~wfull);
    wire r_en = rinc & (~rempty);

    // Addresses for RAM: use lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wbin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rbin[PTR_WIDTH-1:0];

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    // Binary to Gray code conversion (PTR_WIDTH+1 bits)
    function [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH] = bin[PTR_WIDTH];
            for (i=PTR_WIDTH-1; i>=0; i=i-1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray code to Binary conversion (PTR_WIDTH+1 bits)
    function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i=PTR_WIDTH-1; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Write pointer logic (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wptr <= 0;
        end else if (w_en) begin
            wbin <= wbin + 1'b1;
            wptr <= bin2gray(wbin + 1'b1);
        end
    end

    // Read pointer logic (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rptr <= 0;
        end else if (r_en) begin
            rbin <= rbin + 1'b1;
            rptr <= bin2gray(rbin + 1'b1);
        end
    end

    // Synchronize read pointer into write clock domain (2-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_wclk_ff1 <= 0;
            rptr_wclk_ff2 <= 0;
        end else begin
            rptr_wclk_ff1 <= rptr;
            rptr_wclk_ff2 <= rptr_wclk_ff1;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_rclk_ff1 <= 0;
            wptr_rclk_ff2 <= 0;
        end else begin
            wptr_rclk_ff1 <= wptr;
            wptr_rclk_ff2 <= wptr_rclk_ff1;
        end
    end

    // Convert synchronized Gray codes back to binary for comparison
    wire [PTR_WIDTH:0] rbin_sync_in_wclk = gray2bin(rptr_wclk_ff2);
    wire [PTR_WIDTH:0] wbin_sync_in_rclk = gray2bin(wptr_rclk_ff2);

    // Full detection (write domain):
    // FIFO is full if next write pointer equals read pointer with top two bits inverted
    wire [PTR_WIDTH:0] wbin_next = wbin + 1'b1;
    assign wfull = (wbin_next[PTR_WIDTH]     != rbin_sync_in_wclk[PTR_WIDTH]) &&
                   (wbin_next[PTR_WIDTH-1]   != rbin_sync_in_wclk[PTR_WIDTH-1]) &&
                   (wbin_next[PTR_WIDTH-2:0] == rbin_sync_in_wclk[PTR_WIDTH-2:0]);

    // Empty detection (read domain):
    // FIFO is empty if read pointer equals synchronized write pointer
    assign rempty = (rbin == wbin_sync_in_rclk);

    // Register output data on read clock when reading
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM module with unique name to avoid conflict
    dp_ram #(
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


// Dual-port RAM with separate clocks and synchronous read/write ports
module dp_ram #(
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

    // RAM storage array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port: synchronous to wclk
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read port: synchronous to rclk
    // Data read on next cycle after renc and raddr valid
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // Hold last data if no read enable
    end

endmodule