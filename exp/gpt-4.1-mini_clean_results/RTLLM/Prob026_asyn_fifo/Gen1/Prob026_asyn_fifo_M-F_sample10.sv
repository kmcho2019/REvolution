`timescale 1ns / 1ps

module dp_ram_async_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input wire wclk,
    input wire wenc,
    input wire [ADDR_WIDTH-1:0] waddr,
    input wire [WIDTH-1:0] wdata,

    input wire rclk,
    input wire renc,
    input wire [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end else begin
            rdata <= rdata; // hold data if no read enable
        end
    end

endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input wire [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output wire [WIDTH-1:0] rdata
);

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;

    // Gray code pointers
    reg [PTR_WIDTH-1:0] wptr, rptr;

    // Synchronizers for pointers crossing domains
    // Synchronize rptr into wclk domain (two-stage)
    reg [PTR_WIDTH-1:0] rptr_wclk_meta, rptr_wclk_sync;
    // Synchronize wptr into rclk domain (two-stage)
    reg [PTR_WIDTH-1:0] wptr_rclk_meta, wptr_rclk_sync;

    // Function: binary to gray code
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Function: gray code to binary
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Write enable when winc asserted and FIFO not full
    wire wen = winc & ~wfull;
    // Read enable when rinc asserted and FIFO not empty
    wire ren = rinc & ~rempty;

    // Convert Gray pointers to binary for RAM addressing
    wire [PTR_WIDTH-1:0] wptr_bin = gray2bin(wptr);
    wire [PTR_WIDTH-1:0] rptr_bin = gray2bin(rptr);

    // RAM addresses use lower ADDR_WIDTH bits
    wire [ADDR_WIDTH-1:0] waddr_ram = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM with unique module name to avoid redeclaration
    dp_ram_async_fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_dp_ram_async_fifo (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_ram),
        .rdata(rdata)
    );

    // Write pointer update on write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else begin
            if (wen) begin
                waddr_bin <= waddr_bin + 1'b1;
                wptr <= bin2gray(waddr_bin + 1'b1);
            end
        end
    end

    // Read pointer update on read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            if (ren) begin
                raddr_bin <= raddr_bin + 1'b1;
                rptr <= bin2gray(raddr_bin + 1'b1);
            end
        end
    end

    // Synchronize read pointer into write clock domain (two-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_wclk_meta <= 0;
            rptr_wclk_sync <= 0;
        end else begin
            rptr_wclk_meta <= rptr;
            rptr_wclk_sync <= rptr_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain (two-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_rclk_meta <= 0;
            wptr_rclk_sync <= 0;
        end else begin
            wptr_rclk_meta <= wptr;
            wptr_rclk_sync <= wptr_rclk_meta;
        end
    end

    // Full flag logic in write clock domain
    // FIFO full if:
    // wptr == {~rptr[PTR_WIDTH-1], ~rptr[PTR_WIDTH-2], rptr[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_inverted_bits = {~rptr_wclk_sync[PTR_WIDTH-1], ~rptr_wclk_sync[PTR_WIDTH-2], rptr_wclk_sync[PTR_WIDTH-3:0]};
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wfull <= 1'b0;
        else
            wfull <= (wptr == rptr_inverted_bits);
    end

    // Empty flag logic in read clock domain
    // FIFO empty if read pointer == synchronized write pointer
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rempty <= 1'b1;
        else
            rempty <= (rptr == wptr_rclk_sync);
    end

endmodule