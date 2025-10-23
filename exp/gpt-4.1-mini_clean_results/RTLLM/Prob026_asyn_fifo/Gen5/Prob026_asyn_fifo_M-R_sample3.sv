`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input              wclk,
    input              rclk,
    input              wrstn,
    input              rrstn,
    input              winc,
    input              rinc,
    input  [WIDTH-1:0] wdata,
    output             wfull,
    output             rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam GRAY_WIDTH = PTR_WIDTH + 1;

    // Binary pointers (PTR_WIDTH+1 bits for full detection)
    reg [PTR_WIDTH:0] wptr_bin, rptr_bin;

    // Gray code pointers
    reg [GRAY_WIDTH-1:0] wptr_gray, rptr_gray;

    // Synchronizers for pointers crossing clock domains
    reg [GRAY_WIDTH-1:0] rptr_gray_wclk_ff1, rptr_gray_wclk_ff2;
    reg [GRAY_WIDTH-1:0] wptr_gray_rclk_ff1, wptr_gray_rclk_ff2;

    // Next binary pointer combinational functions
    wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + ((winc && !wfull) ? 1'b1 : 1'b0);
    wire [PTR_WIDTH:0] rptr_bin_next = rptr_bin + ((rinc && !rempty) ? 1'b1 : 1'b0);

    // Gray code conversion function
    function [GRAY_WIDTH-1:0] bin2gray(input [PTR_WIDTH:0] bin_in);
        integer i;
        begin
            bin2gray[GRAY_WIDTH-1] = bin_in[PTR_WIDTH];
            for(i = GRAY_WIDTH-2; i >= 0; i = i - 1) begin
                bin2gray[i] = bin_in[i+1] ^ bin_in[i];
            end
        end
    endfunction

    // Gray to binary function
    function [PTR_WIDTH:0] gray2bin(input [GRAY_WIDTH-1:0] gray_in);
        integer j;
        begin
            gray2bin[PTR_WIDTH] = gray_in[GRAY_WIDTH-1];
            for(j = PTR_WIDTH-1; j >= 0; j = j - 1) begin
                gray2bin[j] = gray2bin[j+1] ^ gray_in[j];
            end
        end
    endfunction

    // Update write binary and Gray pointers (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // Update read binary and Gray pointers (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // Synchronize read pointer into write clock domain (two-stage flip-flops)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_ff1 <= 0;
            rptr_gray_wclk_ff2 <= 0;
        end else begin
            rptr_gray_wclk_ff1 <= rptr_gray;
            rptr_gray_wclk_ff2 <= rptr_gray_wclk_ff1;
        end
    end

    // Synchronize write pointer into read clock domain (two-stage flip-flops)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_ff1 <= 0;
            wptr_gray_rclk_ff2 <= 0;
        end else begin
            wptr_gray_rclk_ff1 <= wptr_gray;
            wptr_gray_rclk_ff2 <= wptr_gray_rclk_ff1;
        end
    end

    // RAM addresses - lower PTR_WIDTH bits of the binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write and read enables gated by full and empty signals
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // Full condition: 
    // FIFO full when next write pointer equals read pointer with MSB and MSB-1 inverted and rest bits equal
    assign wfull = ( (bin2gray(wptr_bin_next)[GRAY_WIDTH-3:0] == rptr_gray_wclk_ff2[GRAY_WIDTH-3:0]) &&
                     (bin2gray(wptr_bin_next)[GRAY_WIDTH-1] != rptr_gray_wclk_ff2[GRAY_WIDTH-1]) &&
                     (bin2gray(wptr_bin_next)[GRAY_WIDTH-2] != rptr_gray_wclk_ff2[GRAY_WIDTH-2]) );

    // Empty condition:
    // FIFO empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_ff2);

    // RAM read data
    wire [WIDTH-1:0] ram_rdata;

    // Register output data on read clock when read enable active
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
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

// Dual-port RAM with separate clocks and enables
module dual_port_RAM #(
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule