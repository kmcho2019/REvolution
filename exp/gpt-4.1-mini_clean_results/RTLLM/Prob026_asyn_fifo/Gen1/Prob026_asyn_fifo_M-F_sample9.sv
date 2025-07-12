`timescale 1ns / 1ps

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
    // Synchronize rptr into wclk domain
    reg [PTR_WIDTH-1:0] rptr_wclk_meta, rptr_wclk_sync;
    // Synchronize wptr into rclk domain
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
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // Write pointer increment control
    wire wen = winc && (~wfull);
    // Read pointer increment control
    wire ren = rinc && (~rempty);

    // Convert Gray pointers to binary for addressing RAM
    wire [PTR_WIDTH-1:0] wptr_bin = gray2bin(wptr);
    wire [PTR_WIDTH-1:0] rptr_bin = gray2bin(rptr);

    // Synchronized pointers after crossing clock domains
    wire [PTR_WIDTH-1:0] rptr_sync_bin = gray2bin(rptr_wclk_sync);
    wire [PTR_WIDTH-1:0] wptr_sync_bin = gray2bin(wptr_rclk_sync);

    // RAM address width is ADDR_WIDTH, use lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr_ram = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM module (assumed defined elsewhere)
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_ram),
        .rdata(rdata)
    );

    // Write pointer binary and Gray code update in wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= {PTR_WIDTH{1'b0}};
            wptr <= {PTR_WIDTH{1'b0}};
        end else if (wen) begin
            waddr_bin <= waddr_bin + 1'b1;
            wptr <= bin2gray(waddr_bin + 1'b1);
        end
    end

    // Read pointer binary and Gray code update in rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= {PTR_WIDTH{1'b0}};
            rptr <= {PTR_WIDTH{1'b0}};
        end else if (ren) begin
            raddr_bin <= raddr_bin + 1'b1;
            rptr <= bin2gray(raddr_bin + 1'b1);
        end
    end

    // Synchronize read pointer to write clock domain (two-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_wclk_meta <= {PTR_WIDTH{1'b0}};
            rptr_wclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_wclk_meta <= rptr;
            rptr_wclk_sync <= rptr_wclk_meta;
        end
    end

    // Synchronize write pointer to read clock domain (two-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_rclk_meta <= {PTR_WIDTH{1'b0}};
            wptr_rclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_rclk_meta <= wptr;
            wptr_rclk_sync <= wptr_rclk_meta;
        end
    end

    // Full flag generation in write clock domain
    // FIFO full when wptr == {~rptr[PTR_WIDTH-1:PTR_WIDTH-2], rptr[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_inverted_bits = {~rptr_wclk_sync[PTR_WIDTH-1], ~rptr_wclk_sync[PTR_WIDTH-2], rptr_wclk_sync[PTR_WIDTH-3:0]};
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= (wptr == rptr_inverted_bits);
        end
    end

    // Empty flag generation in read clock domain
    // FIFO empty when rptr == synchronized wptr
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rptr == wptr_rclk_sync);
        end
    end

endmodule