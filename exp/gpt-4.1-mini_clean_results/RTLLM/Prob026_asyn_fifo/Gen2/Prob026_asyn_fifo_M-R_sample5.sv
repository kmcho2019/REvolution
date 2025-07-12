`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,
    input  wire                 rrstn,
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output wire                 wfull,
    output wire                 rempty,
    output wire [WIDTH-1:0]     rdata
);

    // Pointer registers (binary)
    reg  [PTR_WIDTH-1:0] waddr_bin, raddr_bin;
    // Pointer registers (gray code)
    reg  [PTR_WIDTH-1:0] wptr_gray, rptr_gray;

    // Synchronizer registers for pointer crossing domains
    reg  [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    reg  [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    // Write enable: only increment when not full and winc asserted
    wire wen = winc & ~wfull;
    // Read enable: only increment when not empty and rinc asserted
    wire ren = rinc & ~rempty;

    // Binary to Gray function (combinational)
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Gray to Binary function (combinational)
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

    // Update Write Pointer (wclk domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin  <= {PTR_WIDTH{1'b0}};
            wptr_gray  <= {PTR_WIDTH{1'b0}};
        end else if (wen) begin
            waddr_bin  <= waddr_bin + 1'b1;
            wptr_gray  <= bin2gray(waddr_bin + 1'b1);
        end
    end

    // Update Read Pointer (rclk domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin  <= {PTR_WIDTH{1'b0}};
            rptr_gray  <= {PTR_WIDTH{1'b0}};
        end else if (ren) begin
            raddr_bin  <= raddr_bin + 1'b1;
            rptr_gray  <= bin2gray(raddr_bin + 1'b1);
        end
    end

    // Synchronize read pointer into write clock domain (two-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= {PTR_WIDTH{1'b0}};
            rptr_gray_wclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain (two-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= {PTR_WIDTH{1'b0}};
            wptr_gray_rclk_sync <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Convert Gray pointers to binary for RAM addressing
    wire [PTR_WIDTH-1:0] wptr_bin = gray2bin(wptr_gray);
    wire [PTR_WIDTH-1:0] rptr_bin = gray2bin(rptr_gray);

    // RAM addresses use lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr_ram = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate the dual-port RAM submodule
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

    // Convert synchronized pointers back to binary for status logic
    wire [PTR_WIDTH-1:0] rptr_sync_bin = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] wptr_sync_bin = gray2bin(wptr_gray_rclk_sync);

    // Full flag logic (write clock domain)
    // FIFO is full when: write pointer equals read pointer with upper two bits inverted
    wire [PTR_WIDTH-1:0] rptr_gray_inv = {~rptr_gray_wclk_sync[PTR_WIDTH-1], ~rptr_gray_wclk_sync[PTR_WIDTH-2], rptr_gray_wclk_sync[PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray == rptr_gray_inv);

    // Empty flag logic (read clock domain)
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

endmodule