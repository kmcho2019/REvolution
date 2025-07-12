`timescale 1ns / 1ps

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
    input       [WIDTH-1:0] wdata,
    output                  wfull,
    output                  rempty,
    output reg  [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1; // extra bit for full detection

    // Binary pointers
    reg [PTR_EXT-1:0] wptr_bin = 0;
    reg [PTR_EXT-1:0] rptr_bin = 0;

    // Gray code pointers
    wire [PTR_EXT-1:0] wptr_gray;
    wire [PTR_EXT-1:0] rptr_gray;

    // Pointer synchronizers (two-stage flip-flop registers)
    reg [PTR_EXT-1:0] rptr_gray_wclk_sync1 = 0, rptr_gray_wclk_sync2 = 0;
    reg [PTR_EXT-1:0] wptr_gray_rclk_sync1 = 0, wptr_gray_rclk_sync2 = 0;

    // Synchronized pointers in opposite clock domains
    wire [PTR_EXT-1:0] rptr_gray_wclk = rptr_gray_wclk_sync2;
    wire [PTR_EXT-1:0] wptr_gray_rclk = wptr_gray_rclk_sync2;

    // Next pointers (for calculation)
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + (winc & ~wfull);
    wire [PTR_EXT-1:0] rptr_bin_next = rptr_bin + (rinc & ~rempty);

    // Binary to Gray function
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_EXT-1] = bin[PTR_EXT-1];
            for (i = PTR_EXT-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to Binary function
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin_tmp;
        begin
            bin_tmp[PTR_EXT-1] = gray[PTR_EXT-1];
            for (i = PTR_EXT-2; i >= 0; i = i - 1)
                bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
            gray2bin = bin_tmp;
        end
    endfunction

    // Assign Gray pointers from binary pointers
    assign wptr_gray = bin2gray(wptr_bin);
    assign rptr_gray = bin2gray(rptr_bin);

    // Synchronize rptr_gray to wclk domain (two stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync1 <= 0;
            rptr_gray_wclk_sync2 <= 0;
        end else begin
            rptr_gray_wclk_sync1 <= rptr_gray;
            rptr_gray_wclk_sync2 <= rptr_gray_wclk_sync1;
        end
    end

    // Synchronize wptr_gray to rclk domain (two stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync1 <= 0;
            wptr_gray_rclk_sync2 <= 0;
        end else begin
            wptr_gray_rclk_sync1 <= wptr_gray;
            wptr_gray_rclk_sync2 <= wptr_gray_rclk_sync1;
        end
    end

    // Full condition:
    // When next write pointer's gray code equals inverted upper bits of synchronized rptr_gray plus lower bits equal
    // According to the standard method:
    // Full when wptr_gray_next[PTR_EXT-1:PTR_EXT-2] == ~rptr_gray_sync[PTR_EXT-1:PTR_EXT-2]
    // AND wptr_gray_next[PTR_EXT-3:0] == rptr_gray_sync[PTR_EXT-3:0]
    wire full_cond = ((bin2gray(wptr_bin_next)[PTR_EXT-1]   != rptr_gray_wclk[PTR_EXT-1]) &&
                      (bin2gray(wptr_bin_next)[PTR_EXT-2]   != rptr_gray_wclk[PTR_EXT-2]) &&
                      (bin2gray(wptr_bin_next)[PTR_EXT-3:0] == rptr_gray_wclk[PTR_EXT-3:0]));

    assign wfull = full_cond;

    // Empty condition: rptr_gray == synchronized wptr_gray in rclk domain
    assign rempty = (rptr_gray == wptr_gray_rclk);

    // Update write pointer on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Update read pointer on rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Extract RAM addresses as lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write and read enables gate with full and empty signals
    wire wen = winc & ~wfull;
    wire ren = rinc & ~rempty;

    // RAM data output
    wire [WIDTH-1:0] ram_rdata;

    // Update rdata synchronously with rclk when reading
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= 0;
        else if (ren)
            rdata <= ram_rdata;
    end

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

endmodule


// Two-port RAM used by asynchronous FIFO
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input       [$clog2(DEPTH)-1:0] waddr,
    input       [WIDTH-1:0] wdata,
    input                   rclk,
    input                   renc,
    input       [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0] rdata
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