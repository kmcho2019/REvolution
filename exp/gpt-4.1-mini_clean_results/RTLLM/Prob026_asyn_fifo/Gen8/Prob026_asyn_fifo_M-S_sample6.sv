`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                wclk,
    input                rclk,
    input                wrstn,     // active low reset write domain
    input                rrstn,     // active low reset read domain
    input                winc,      // write increment pulse
    input                rinc,      // read increment pulse
    input  [WIDTH-1:0]   wdata,
    output reg           wfull,
    output reg           rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // extra bit for full detection

    // Binary write pointer
    reg [PTR_WIDTH-1:0] wptr_bin;
    // Gray-coded write pointer
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Binary read pointer
    reg [PTR_WIDTH-1:0] rptr_bin;
    // Gray-coded read pointer
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Next write pointer in binary (increment if write enabled and not full)
    wire winc_valid = winc & ~wfull;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + winc_valid;

    // Next read pointer in binary (increment if read enabled and not empty)
    wire rinc_valid = rinc & ~rempty;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + rinc_valid;

    // Function to convert binary to Gray code
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Update write pointer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc_valid) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // Update read pointer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc_valid) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // Synchronize read pointer into write clock domain (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage synchronizer)
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // Function to convert Gray code to binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // Convert synchronized pointers to binary for address and flag comparison
    wire [PTR_WIDTH-1:0] rptr_bin_sync = gray2bin(rptr_gray_wclk_sync);
    wire [PTR_WIDTH-1:0] wptr_bin_sync = gray2bin(wptr_gray_rclk_sync);

    // Extract RAM addresses from lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM write enable and read enable signals
    wire w_en = winc_valid;
    wire r_en = rinc_valid;

    // Full flag generation (write clock domain)
    // FIFO full when write pointer is one ahead of read pointer with top two bits inverted
    wire full_flag = ( (wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_wclk_sync[PTR_WIDTH-1]) &&
                       (wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_wclk_sync[PTR_WIDTH-2]) &&
                       (wptr_gray[PTR_WIDTH-3:0] ==  rptr_gray_wclk_sync[PTR_WIDTH-3:0]) );

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 1'b0;
        else wfull <= full_flag;
    end

    // Empty flag generation (read clock domain)
    // FIFO empty when read pointer equals synchronized write pointer
    wire empty_flag = (rptr_gray == wptr_gray_rclk_sync);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1'b1;
        else rempty <= empty_flag;
    end

    // Read data output register
    reg [WIDTH-1:0] ram_rdata;

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

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule