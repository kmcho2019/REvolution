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
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1;

    // Pointer registers
    reg [PTR_EXT-1:0] wptr_bin, rptr_bin;
    reg [PTR_EXT-1:0] wptr_gray, rptr_gray;

    // Pointer increments
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + 1;
    wire [PTR_EXT-1:0] rptr_bin_next = rptr_bin + 1;

    // Gray code conversion functions
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        reg [PTR_EXT-1:0] gray;
    begin
        gray[PTR_EXT-1] = bin[PTR_EXT-1];
        for (i = PTR_EXT-2; i >= 0; i = i - 1)
            gray[i] = bin[i+1] ^ bin[i];
        bin2gray = gray;
    end
    endfunction

    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin;
    begin
        bin[PTR_EXT-1] = gray[PTR_EXT-1];
        for (i = PTR_EXT-2; i >= 0; i = i -1)
            bin[i] = bin[i+1] ^ gray[i];
        gray2bin = bin;
    end
    endfunction

    // Pointer increment control
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // Update write pointer binary & gray
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // Update read pointer binary & gray
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // Pointer synchronization registers
    reg [PTR_EXT-1:0] rptr_gray_sync_1, rptr_gray_sync_2;
    reg [PTR_EXT-1:0] wptr_gray_sync_1, wptr_gray_sync_2;

    // Synchronize read pointer into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_1 <= 0;
            rptr_gray_sync_2 <= 0;
        end else begin
            rptr_gray_sync_1 <= rptr_gray;
            rptr_gray_sync_2 <= rptr_gray_sync_1;
        end
    end

    // Synchronize write pointer into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_1 <= 0;
            wptr_gray_sync_2 <= 0;
        end else begin
            wptr_gray_sync_1 <= wptr_gray;
            wptr_gray_sync_2 <= wptr_gray_sync_1;
        end
    end

    // Synchronized pointer binary versions for comparison
    wire [PTR_EXT-1:0] rptr_bin_sync = gray2bin(rptr_gray_sync_2);
    wire [PTR_EXT-1:0] wptr_bin_sync = gray2bin(wptr_gray_sync_2);

    // Addresses to RAM use lower PTR_WIDTH bits of binary pointers
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // FIFO full when write pointer equals read pointer with inverted top two bits
    assign wfull = (wptr_gray == {~rptr_gray_sync_2[PTR_EXT-1:PTR_EXT-2], rptr_gray_sync_2[PTR_EXT-3:0]});

    // FIFO empty when pointers equal
    assign rempty = (rptr_gray == wptr_gray_sync_2);

    // Register read data output on rclk when reading
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate the dual-port RAM submodule
    async_fifo_dual_port_RAM #(
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

endmodule


module async_fifo_dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                         wclk,
    input                         wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]        wdata,
    input                         rclk,
    input                         renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]        rdata
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