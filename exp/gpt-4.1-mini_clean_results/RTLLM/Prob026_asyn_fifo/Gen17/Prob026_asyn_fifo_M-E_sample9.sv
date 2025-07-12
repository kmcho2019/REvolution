`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input               wclk,
    input               rclk,
    input               wrstn,  // active low synchronous reset in write domain
    input               rrstn,  // active low synchronous reset in read domain
    input               winc,   // write increment (write enable)
    input               rinc,   // read increment (read enable)
    input  [WIDTH-1:0]  wdata,  // input data bus
    output              wfull,  // FIFO full flag (write domain)
    output              rempty, // FIFO empty flag (read domain)
    output reg [WIDTH-1:0] rdata // data output bus (read domain)
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam ADDR_WIDTH = PTR_WIDTH; // number of bits addressing DEPTH locations

    // ---------------------------
    // Binary and Gray pointer registers in write domain
    reg [PTR_WIDTH:0] wbin, wbin_next;
    wire [PTR_WIDTH:0] wgray, wgray_next;

    // Binary and Gray pointer registers in read domain
    reg [PTR_WIDTH:0] rbin, rbin_next;
    wire [PTR_WIDTH:0] rgray, rgray_next;

    // Pointer synchronization signals (Gray code pointers)
    wire [PTR_WIDTH:0] rgray_sync_wclk; // read pointer synchronized into write clock domain
    wire [PTR_WIDTH:0] wgray_sync_rclk; // write pointer synchronized into read clock domain

    // Write and read enable gating by full/empty signals
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Write and read addresses for RAM
    wire [ADDR_WIDTH-1:0] waddr = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rbin[ADDR_WIDTH-1:0];

    // Read data from RAM
    wire [WIDTH-1:0] ram_rdata;

    // -----------------------------------
    // Binary to Gray code conversion module (combinational)
    bin2gray #(.WIDTH(PTR_WIDTH+1)) bin2gray_inst_w (
        .bin(wbin_next),
        .gray(wgray_next)
    );

    bin2gray #(.WIDTH(PTR_WIDTH+1)) bin2gray_inst_r (
        .bin(rbin_next),
        .gray(rgray_next)
    );

    // -----------------------------------
    // Gray to Binary conversion module (combinational)
    gray2bin #(.WIDTH(PTR_WIDTH+1)) gray2bin_inst_w (
        .gray(wgray_sync_rclk),
        .bin(wbin_sync_rclk
            )
    );

    gray2bin #(.WIDTH(PTR_WIDTH+1)) gray2bin_inst_r (
        .gray(rgray_sync_wclk),
        .bin(rbin_sync_wclk
            )
    );

    // Write pointer binary increment and gray update (write clock domain)
    always @(posedge wclk) begin
        if (~wrstn) begin
            wbin <= 0;
        end else if (w_en) begin
            wbin <= wbin + 1'b1;
        end
    end
    assign wbin_next = w_en ? wbin + 1'b1 : wbin;

    // Gray code for current write pointer
    assign wgray = (wbin == 0) ? 0 : bin2gray_function(wbin);
    assign wgray_next = (wbin_next == 0) ? 0 : bin2gray_function(wbin_next);

    // Read pointer binary increment and gray update (read clock domain)
    always @(posedge rclk) begin
        if (~rrstn) begin
            rbin <= 0;
        end else if (r_en) begin
            rbin <= rbin + 1'b1;
        end
    end
    assign rbin_next = r_en ? rbin + 1'b1 : rbin;

    // Gray code for current read pointer
    assign rgray = (rbin == 0) ? 0 : bin2gray_function(rbin);
    assign rgray_next = (rbin_next == 0) ? 0 : bin2gray_function(rbin_next);

    // -----------------------------------
    // Synchronize read pointer into write clock domain
    pointer_sync #(.WIDTH(PTR_WIDTH+1)) sync_rptr_to_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .din(rgray),
        .dout(rgray_sync_wclk)
    );

    // Synchronize write pointer into read clock domain
    pointer_sync #(.WIDTH(PTR_WIDTH+1)) sync_wptr_to_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .din(wgray),
        .dout(wgray_sync_rclk)
    );

    // Convert synchronized Gray pointers back to binary for comparison
    wire [PTR_WIDTH:0] rbin_sync_wclk;
    wire [PTR_WIDTH:0] wbin_sync_rclk;

    assign rbin_sync_wclk = gray2bin_function(rgray_sync_wclk);
    assign wbin_sync_rclk = gray2bin_function(wgray_sync_rclk);

    // --------------------------
    // Full detection logic (write domain):
    // FIFO full when write pointer is one ahead of read pointer with upper bits inverted
    wire full_check;
    assign full_check = ( (wbin_next[PTR_WIDTH]     != rbin_sync_wclk[PTR_WIDTH])   &&
                          (wbin_next[PTR_WIDTH-1]   != rbin_sync_wclk[PTR_WIDTH-1]) &&
                          (wbin_next[PTR_WIDTH-2:0] == rbin_sync_wclk[PTR_WIDTH-2:0]) );

    assign wfull = full_check;

    // --------------------------
    // Empty detection logic (read domain):
    // FIFO empty when read pointer equals synchronized write pointer
    assign rempty = (rbin == wbin_sync_rclk);

    // --------------------------
    // Output data register (read clock domain)
    always @(posedge rclk) begin
        if (~rrstn)
            rdata <= 0;
        else if (r_en)
            rdata <= ram_rdata;
    end

    // --------------------------
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


    // ---------
    // Combinational Gray code conversion function
    function [PTR_WIDTH:0] bin2gray_function(input [PTR_WIDTH:0] b);
        integer i;
        begin
            bin2gray_function[PTR_WIDTH] = b[PTR_WIDTH];
            for (i=PTR_WIDTH-1; i>=0; i=i-1) begin
                bin2gray_function[i] = b[i+1] ^ b[i];
            end
        end
    endfunction

    // Combinational Gray to binary conversion function
    function [PTR_WIDTH:0] gray2bin_function(input [PTR_WIDTH:0] g);
        integer i;
        begin
            gray2bin_function[PTR_WIDTH] = g[PTR_WIDTH];
            for (i=PTR_WIDTH-1; i>=0; i=i-1) begin
                gray2bin_function[i] = gray2bin_function[i+1] ^ g[i];
            end
        end
    endfunction

endmodule


// -----------------------------------------------------
// Dual-port RAM with synchronous write and read ports
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,
    input                    wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]       wdata,
    input                    rclk,
    input                    renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]   rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end else begin
            rdata <= rdata; // Hold last data if no read
        end
    end

endmodule


// -----------------------------------------------------
// Generic 2-stage synchronizer for Gray-coded pointers
module pointer_sync #(
    parameter WIDTH = 4
)(
    input                  clk,
    input                  rst_n,
    input  [WIDTH-1:0]     din,
    output reg [WIDTH-1:0] dout
);

    reg [WIDTH-1:0] sync_ff1;
    always @(posedge clk) begin
        if (~rst_n) begin
            sync_ff1 <= {WIDTH{1'b0}};
            dout     <= {WIDTH{1'b0}};
        end else begin
            sync_ff1 <= din;
            dout     <= sync_ff1;
        end
    end

endmodule


// -----------------------------------------------------
// Separate module for binary to Gray code conversion (combinational)
module bin2gray #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] bin,
    output [WIDTH-1:0] gray
);
    genvar i;
    assign gray[WIDTH-1] = bin[WIDTH-1];
    generate
        for (i=WIDTH-2; i>=0; i=i-1) begin : gen_gray_bits
            assign gray[i] = bin[i+1] ^ bin[i];
        end
    endgenerate
endmodule


// -----------------------------------------------------
// Separate module for Gray to binary conversion (combinational)
module gray2bin #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] gray,
    output [WIDTH-1:0] bin
);
    genvar i;
    assign bin[WIDTH-1] = gray[WIDTH-1];
    generate
        for (i=WIDTH-2; i>=0; i=i-1) begin : gen_bin_bits
            assign bin[i] = bin[i+1] ^ gray[i];
        end
    endgenerate
endmodule