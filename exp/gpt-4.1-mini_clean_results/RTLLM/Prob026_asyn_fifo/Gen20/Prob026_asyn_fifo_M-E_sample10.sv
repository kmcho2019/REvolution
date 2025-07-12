`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                 wclk,   // write clock
    input                 rclk,   // read clock
    input                 wrstn,  // async active-low write reset
    input                 rrstn,  // async active-low read reset
    input                 winc,   // write increment
    input                 rinc,   // read increment
    input  [WIDTH-1:0]    wdata,  // write data input
    output                wfull,  // write full signal
    output                rempty, // read empty signal
    output reg [WIDTH-1:0] rdata  // read data output (registered)
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // one bit wider for full detection

    // Write domain binary and gray pointers
    reg [PTR_WIDTH-1:0] wbin;
    reg [PTR_WIDTH-1:0] wgray;

    // Read domain binary and gray pointers
    reg [PTR_WIDTH-1:0] rbin;
    reg [PTR_WIDTH-1:0] rgray;

    // Synchronized pointers crossing domains
    wire [PTR_WIDTH-1:0] rgray_sync_wclk;
    wire [PTR_WIDTH-1:0] wgray_sync_rclk;

    // Write enable if not full and winc asserted
    wire w_en = winc & ~wfull;
    // Read enable if not empty and rinc asserted
    wire r_en = rinc & ~rempty;

    // Binary to Gray code function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to binary function
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Write pointer logic (wclk domain)
    wire [PTR_WIDTH-1:0] wbin_next = wbin + (w_en ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] wgray_next = bin2gray(wbin_next);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin  <= 0;
            wgray <= 0;
        end else begin
            if (w_en) begin
                wbin  <= wbin_next;
                wgray <= wgray_next;
            end
        end
    end

    // Read pointer logic (rclk domain)
    wire [PTR_WIDTH-1:0] rbin_next = rbin + (r_en ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] rgray_next = bin2gray(rbin_next);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin  <= 0;
            rgray <= 0;
            rdata <= {WIDTH{1'b0}};
        end else begin
            if (r_en) begin
                rbin  <= rbin_next;
                rgray <= rgray_next;
            end
            // rdata is updated on read enable with the RAM data output
            if (r_en)
                rdata <= ram_rdata;
        end
    end

    // Synchronize pointers crossing clock domains
    // Read pointer gray into write clock domain
    gray_sync #(
        .WIDTH(PTR_WIDTH)
    ) sync_r_to_w (
        .clk(wclk),
        .rstn(wrstn),
        .in_gray(rgray),
        .out_gray(rgray_sync_wclk)
    );

    // Write pointer gray into read clock domain
    gray_sync #(
        .WIDTH(PTR_WIDTH)
    ) sync_w_to_r (
        .clk(rclk),
        .rstn(rrstn),
        .in_gray(wgray),
        .out_gray(wgray_sync_rclk)
    );

    // Decode pointers back to binary for comparison/addressing
    wire [PTR_WIDTH-1:0] rbin_sync_wclk = gray2bin(rgray_sync_wclk);
    wire [PTR_WIDTH-1:0] wbin_sync_rclk = gray2bin(wgray_sync_rclk);

    // Generate addresses to RAM by taking lower ADDR_WIDTH bits of pointers
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // FIFO full condition: next write pointer equals read pointer with MSBs inverted
    // full when: wgray_next[PTR_WIDTH-1:PTR_WIDTH-2] = ~rgray_sync_wclk[PTR_WIDTH-1:PTR_WIDTH-2]
    //            and lower bits equal
    assign wfull = (
        (wgray_next[PTR_WIDTH-1]     != rgray_sync_wclk[PTR_WIDTH-1]) &&
        (wgray_next[PTR_WIDTH-2]     != rgray_sync_wclk[PTR_WIDTH-2]) &&
        (wgray_next[PTR_WIDTH-3:0]  == rgray_sync_wclk[PTR_WIDTH-3:0])
    );

    // FIFO empty condition: read pointer equals synchronized write pointer
    assign rempty = (rgray == wgray_sync_rclk);

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

    wire [WIDTH-1:0] ram_rdata;

endmodule


// Gray code synchronizer for crossing clock domains
module gray_sync #(
    parameter WIDTH = 5
)(
    input  wire               clk,
    input  wire               rstn,      // Active low async reset
    input  wire [WIDTH-1:0]   in_gray,
    output reg  [WIDTH-1:0]   out_gray
);

    reg [WIDTH-1:0] sync_ff1;
    reg [WIDTH-1:0] sync_ff2;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= {WIDTH{1'b0}};
            sync_ff2 <= {WIDTH{1'b0}};
            out_gray <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= in_gray;
            sync_ff2 <= sync_ff1;
            out_gray <= sync_ff2;
        end
    end

endmodule


// Dual-port RAM with independent clocks for write/read, synchronous write/read enables
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

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port (clocked, write enable)
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port (clocked, read enable)
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule