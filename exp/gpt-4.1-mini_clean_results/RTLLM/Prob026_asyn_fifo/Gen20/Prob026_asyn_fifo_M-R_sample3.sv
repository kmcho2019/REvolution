`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input              wclk,
    input              rclk,
    input              wrstn,   // active low write reset
    input              rrstn,   // active low read reset
    input              winc,
    input              rinc,
    input  [WIDTH-1:0] wdata,
    output             wfull,
    output             rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Dual-port RAM submodule definition
    // Declared below and instantiated
    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire wenc = winc & ~wfull;
    wire renc = rinc & ~rempty;

    // Write and read binary pointers
    reg [ADDR_WIDTH:0] wbin, rbin;
    wire [ADDR_WIDTH:0] wbin_next, rbin_next;

    // Write and read Gray pointers
    reg [ADDR_WIDTH:0] wptr, rptr;

    // Synchronizers for pointers crossing clock domains
    reg [ADDR_WIDTH:0] rptr_wclk_1, rptr_wclk_2;
    reg [ADDR_WIDTH:0] wptr_rclk_1, wptr_rclk_2;

    // Next pointer calculations (binary)
    assign wbin_next = wbin + (wenc ? 1'b1 : 1'b0);
    assign rbin_next = rbin + (renc ? 1'b1 : 1'b0);

    // Function: binary to Gray code
    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Convert next pointers to Gray code (combinational)
    wire [ADDR_WIDTH:0] wptr_next = bin2gray(wbin_next);
    wire [ADDR_WIDTH:0] rptr_next = bin2gray(rbin_next);

    // Write pointer update on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wbin <= 0;
            wptr <= 0;
        end else begin
            wbin <= wbin_next;
            wptr <= wptr_next;
        end
    end

    // Read pointer update on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rbin <= 0;
            rptr <= 0;
        end else begin
            rbin <= rbin_next;
            rptr <= rptr_next;
        end
    end

    // Synchronize read pointer into write clock domain (2-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_wclk_1 <= 0;
            rptr_wclk_2 <= 0;
        end else begin
            rptr_wclk_1 <= rptr;
            rptr_wclk_2 <= rptr_wclk_1;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_rclk_1 <= 0;
            wptr_rclk_2 <= 0;
        end else begin
            wptr_rclk_1 <= wptr;
            wptr_rclk_2 <= wptr_rclk_1;
        end
    end

    // Extract synchronized pointers
    wire [ADDR_WIDTH:0] rptr_sync_wclk = rptr_wclk_2;
    wire [ADDR_WIDTH:0] wptr_sync_rclk = wptr_rclk_2;

    // Full condition (write clock domain)
    // FIFO is full when write pointer's MSBs are inverted compared to read pointer MSBs and remaining bits equal
    wire full_flag = (wptr[ADDR_WIDTH]     != rptr_sync_wclk[ADDR_WIDTH])   &&
                     (wptr[ADDR_WIDTH-1]   != rptr_sync_wclk[ADDR_WIDTH-1]) &&
                     (wptr[ADDR_WIDTH-2:0] == rptr_sync_wclk[ADDR_WIDTH-2:0]);

    assign wfull = full_flag;

    // Empty condition (read clock domain)
    // FIFO is empty when read pointer equals synchronized write pointer
    assign rempty = (rptr == wptr_sync_rclk);

    // RAM address inputs derived from binary pointers lower bits
    assign waddr = wbin[ADDR_WIDTH-1:0];
    assign raddr = rbin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM submodule
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
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


// Dual-port RAM submodule
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
    // Memory declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write process (write clock domain)
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read process (read clock domain)
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule