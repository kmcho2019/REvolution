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

    // Calculate address width based on DEPTH
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // extra bit for full detection

    // Dual-port RAM instantiation
    wire wenc = winc & ~wfull;
    wire renc = rinc & ~rempty;

    // Write pointer binary and gray
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] wptr, wptr_buff;

    // Read pointer binary and gray
    reg [PTR_WIDTH-1:0] raddr_bin;
    reg [PTR_WIDTH-1:0] rptr, rptr_buff;

    // Synchronized pointers
    reg [PTR_WIDTH-1:0] rptr_syn1, rptr_syn2; // rptr synchronized into wclk domain
    reg [PTR_WIDTH-1:0] wptr_syn1, wptr_syn2; // wptr synchronized into rclk domain

    // Binary to Gray conversion function
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Gray to Binary conversion function
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    // Write pointer logic (binary counter)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else begin
            if (wenc) begin
                waddr_bin <= waddr_bin + 1'b1;
            end
            wptr <= bin2gray(waddr_bin);
            wptr_buff <= wptr;
        end
    end

    // Read pointer logic (binary counter)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
        end else begin
            if (renc) begin
                raddr_bin <= raddr_bin + 1'b1;
            end
            rptr <= bin2gray(raddr_bin);
            rptr_buff <= rptr;
        end
    end

    // Synchronize read pointer into write clock domain (two-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn1 <= 0;
            rptr_syn2 <= 0;
        end else begin
            rptr_syn1 <= rptr_buff;
            rptr_syn2 <= rptr_syn1;
        end
    end

    // Synchronize write pointer into read clock domain (two-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn1 <= 0;
            wptr_syn2 <= 0;
        end else begin
            wptr_syn1 <= wptr_buff;
            wptr_syn2 <= wptr_syn1;
        end
    end

    // Full detection:
    // FIFO is full when:
    // wptr[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_syn2[PTR_WIDTH-1:PTR_WIDTH-2]
    // and wptr[PTR_WIDTH-3:0] == rptr_syn2[PTR_WIDTH-3:0]
    wire full_cond_msb = (wptr[PTR_WIDTH-1]   != rptr_syn2[PTR_WIDTH-1]) &&
                        (wptr[PTR_WIDTH-2]   != rptr_syn2[PTR_WIDTH-2]);
    wire full_cond_lsb = (wptr[PTR_WIDTH-3:0] == rptr_syn2[PTR_WIDTH-3:0]);
    assign wfull = full_cond_msb & full_cond_lsb;

    // Empty detection:
    // FIFO is empty when read pointer equals synchronized write pointer
    assign rempty = (rptr == wptr_syn2);

    // RAM address is lower bits of binary pointer
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    // RAM memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            // Hold previous data if no read enable
            rdata <= rdata;
        end
    end

endmodule