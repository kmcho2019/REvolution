`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,
    input                 rclk,
    input                 wrstn,   // Active low synchronous reset for write domain
    input                 rrstn,   // Active low synchronous reset for read domain
    input                 winc,    // Write increment (write request)
    input                 rinc,    // Read increment (read request)
    input  [WIDTH-1:0]    wdata,   // Data to write
    output                wfull,   // FIFO full flag (write domain)
    output                rempty,  // FIFO empty flag (read domain)
    output reg [WIDTH-1:0] rdata   // Data output
);

    // Calculate pointer width from depth
    localparam PTR_WIDTH = $clog2(DEPTH);   // e.g. 4 for DEPTH=16

    // Binary pointers (write and read), one extra bit for full/empty detection
    reg [PTR_WIDTH:0] wbin; // PTR_WIDTH + 1 bits
    reg [PTR_WIDTH:0] rbin;

    // Gray code pointers
    reg [PTR_WIDTH:0] wptr; // Write pointer in Gray code
    reg [PTR_WIDTH:0] rptr; // Read pointer in Gray code

    // Pointer synchronizers for crossing clock domains (two-stage)
    reg [PTR_WIDTH:0] rptr_wclk1, rptr_wclk2; // read pointer synchronized to write clock domain
    reg [PTR_WIDTH:0] wptr_rclk1, wptr_rclk2; // write pointer synchronized to read clock domain

    // RAM address widths (lower PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr = wbin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rbin[PTR_WIDTH-1:0];

    // Write and read enable signals gated with full and empty flags
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    //
    // Binary to Gray code conversion function (PTR_WIDTH+1 bits)
    //
    function [PTR_WIDTH:0] bin2gray(input [PTR_WIDTH:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH] = bin[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    //
    // Gray code to binary conversion function (PTR_WIDTH+1 bits)
    //
    function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction


    //
    // Write pointer logic (write clock domain)
    //
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wptr <= 0;
        end else if (w_en) begin
            wbin <= wbin + 1'b1;
            wptr <= bin2gray(wbin + 1'b1);
        end
    end

    //
    // Read pointer logic (read clock domain)
    //
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rptr <= 0;
        end else if (r_en) begin
            rbin <= rbin + 1'b1;
            rptr <= bin2gray(rbin + 1'b1);
        end
    end

    //
    // Synchronize read pointer into write clock domain (two-stage synchronizer)
    //
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_wclk1 <= 0;
            rptr_wclk2 <= 0;
        end else begin
            rptr_wclk1 <= rptr;
            rptr_wclk2 <= rptr_wclk1;
        end
    end

    //
    // Synchronize write pointer into read clock domain (two-stage synchronizer)
    //
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_rclk1 <= 0;
            wptr_rclk2 <= 0;
        end else begin
            wptr_rclk1 <= wptr;
            wptr_rclk2 <= wptr_rclk1;
        end
    end

    //
    // Convert synchronized Gray pointers back to binary for comparison
    //
    wire [PTR_WIDTH:0] rbin_sync = gray2bin(rptr_wclk2);
    wire [PTR_WIDTH:0] wbin_sync = gray2bin(wptr_rclk2);

    //
    // Full flag logic (write domain)
    //
    // FIFO is full when:
    //   The MSB and second MSB bits of wbin_next are the inverse of rbin_sync, 
    //   and the lower bits are equal.
    //
    wire [PTR_WIDTH:0] wbin_next = wbin + 1'b1;
    assign wfull = ((wbin_next[PTR_WIDTH]     != rbin_sync[PTR_WIDTH]) &&
                    (wbin_next[PTR_WIDTH-1]   != rbin_sync[PTR_WIDTH-1]) &&
                    (wbin_next[PTR_WIDTH-2:0] == rbin_sync[PTR_WIDTH-2:0]));

    //
    // Empty flag logic (read domain)
    //
    // FIFO is empty when read and synchronized write pointers are equal.
    //
    assign rempty = (rbin == wbin_sync);

    //
    // Data output register: latch RAM read data on read enable and read clock
    //
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    //
    // Instantiate the dual-port RAM module interface (black box)
    //
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


//
// Black box declaration for dual-port RAM module
// The actual RAM module should be provided separately in the project or simulation environment.
//
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                       wclk,
    input                       wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]          wdata,
    input                       rclk,
    input                       renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);
    // No internal implementation here to prevent multiple definition errors.
    // Provide implementation separately or via FPGA vendor primitives.
endmodule