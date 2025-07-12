`timescale 1ns / 1ps

// Dual-port RAM module with separate read and write clocks
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                 wclk,
    input  wire                 wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]     wdata,

    input  wire                 rclk,
    input  wire                 renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]     rdata
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire                wclk,
    input  wire                rclk,
    input  wire                wrstn,
    input  wire                rrstn,
    input  wire                winc,
    input  wire                rinc,
    input  wire [WIDTH-1:0]    wdata,
    output wire                wfull,
    output wire                rempty,
    output wire [WIDTH-1:0]    rdata
);

    // Binary pointers
    reg [PTR_WIDTH-1:0] wbin, rbin;
    wire [PTR_WIDTH-1:0] wbin_next = wbin + (winc & ~wfull);
    wire [PTR_WIDTH-1:0] rbin_next = rbin + (rinc & ~rempty);

    // Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Gray pointers
    reg [PTR_WIDTH-1:0] wptr_gray, rptr_gray;

    // Pointer synchronizers (2-stage) for crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    // Update write binary pointer and gray pointer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin <= 0;
            wptr_gray <= 0;
        end else begin
            wbin <= wbin_next;
            wptr_gray <= bin2gray(wbin_next);
        end
    end

    // Update read binary pointer and gray pointer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin <= 0;
            rptr_gray <= 0;
        end else begin
            rbin <= rbin_next;
            rptr_gray <= bin2gray(rbin_next);
        end
    end

    // Synchronize read pointer Gray code into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer Gray code into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Convert synchronized Gray pointers back to binary for comparison
    wire [PTR_WIDTH-1:0] rbin_sync_in_wclk = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] wbin_sync_in_rclk = gray2bin(wptr_gray_rclk_sync);

    // RAM addresses are lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr_ram = wbin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr_ram = rbin[ADDR_WIDTH-1:0];

    // RAM write and read enables
    wire wen = winc & ~wfull;
    wire ren = rinc & ~rempty;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_ram),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_ram),
        .rdata(rdata)
    );

    // Full condition: write pointer is one ahead of read pointer with MSB bits inverted
    // Condition: wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1], ~rptr_gray_sync[PTR_WIDTH-2], rptr_gray_sync[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_gray_inv_msb =
        {~rptr_gray_wclk_sync[PTR_WIDTH-1],
         ~rptr_gray_wclk_sync[PTR_WIDTH-2],
         rptr_gray_wclk_sync[PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray == rptr_gray_inv_msb);

    // Empty condition: read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

endmodule