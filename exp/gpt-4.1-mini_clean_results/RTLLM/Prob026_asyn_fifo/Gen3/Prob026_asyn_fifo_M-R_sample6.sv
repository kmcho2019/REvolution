`timescale 1ns / 1ps

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                 wclk,
    input  wire                 wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,

    input  wire                 rclk,
    input  wire                 renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
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

    // Functions for Gray code conversions
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


    // --- Pointer registers and next values ---
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray, wptr_gray;

    // Pointer increments combinational logic
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + 1;

    // Gray code of next pointers assigned combinationally
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_bin_next);
    wire [PTR_WIDTH-1:0] rptr_gray_next = bin2gray(rptr_bin_next);

    // Write pointer register
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Read pointer register
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end


    // --- Synchronizers for crossing clock domains ---
    // Synchronize read pointer into write clock domain
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_wclk <= 0;
            rptr_gray_sync2_wclk <= 0;
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Synchronize write pointer into read clock domain
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_rclk <= 0;
            wptr_gray_sync2_rclk <= 0;
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end


    // --- Convert synchronized Gray pointers to binary for addressing ---
    wire [PTR_WIDTH-1:0] rptr_sync_bin_wclk = gray2bin(rptr_gray_sync2_wclk);
    wire [PTR_WIDTH-1:0] wptr_sync_bin_rclk = gray2bin(wptr_gray_sync2_rclk);

    // RAM addresses use lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];


    // --- Instantiate dual-port RAM ---
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(winc & ~wfull),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & ~rempty),
        .raddr(raddr),
        .rdata(rdata)
    );


    // --- Full and Empty flag logic (combinational) ---

    // Full when write pointer equals read pointer inverted on MSBs per problem statement:
    // wptr == {~rptr_msb, ~rptr_msb-1, rptr_rest}
    wire [PTR_WIDTH-1:0] rptr_gray_sync_inv = {
        ~rptr_gray_sync2_wclk[PTR_WIDTH-1],
        ~rptr_gray_sync2_wclk[PTR_WIDTH-2],
        rptr_gray_sync2_wclk[PTR_WIDTH-3:0]
    };
    assign wfull = (wptr_gray == rptr_gray_sync_inv);

    // Empty when read pointer equals synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync2_rclk);

endmodule