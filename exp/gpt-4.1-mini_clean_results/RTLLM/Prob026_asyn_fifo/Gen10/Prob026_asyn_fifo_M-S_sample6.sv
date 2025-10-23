`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // Active low reset for write domain
    input                   rrstn,      // Active low reset for read domain
    input                   winc,       // Write increment enable
    input                   rinc,       // Read increment enable
    input  [WIDTH-1:0]      wdata,      // Write data input
    output                  wfull,      // FIFO full (write domain)
    output                  rempty,     // FIFO empty (read domain)
    output [WIDTH-1:0]      rdata       // Read data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary pointers
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray-coded pointers (combinational)
    wire [PTR_WIDTH-1:0] wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // Synchronize read pointer into write clock domain (double flip-flop)
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync1, rptr_gray_wclk_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync1 <= 0;
            rptr_gray_wclk_sync2 <= 0;
        end else begin
            rptr_gray_wclk_sync1 <= rptr_gray;
            rptr_gray_wclk_sync2 <= rptr_gray_wclk_sync1;
        end
    end

    // Synchronize write pointer into read clock domain (double flip-flop)
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync1, wptr_gray_rclk_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync1 <= 0;
            wptr_gray_rclk_sync2 <= 0;
        end else begin
            wptr_gray_rclk_sync1 <= wptr_gray;
            wptr_gray_rclk_sync2 <= wptr_gray_rclk_sync1;
        end
    end

    // Convert synchronized Gray code pointers back to binary (function)
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    wire [PTR_WIDTH-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk_sync2);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk_sync2);

    // Write pointer logic
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc && !wfull ? 1'b1 : 1'b0);

    // Full detection: when write pointer is one ahead of read pointer with inverted two MSBs and rest equal
    wire full_condition = (wptr_gray_next(wptr_bin_next) == full_check_mask(rptr_gray_wclk_sync2));

    function [PTR_WIDTH-1:0] wptr_gray_next;
        input [PTR_WIDTH-1:0] bin;
        begin
            wptr_gray_next = (bin >> 1) ^ bin;
        end
    endfunction

    function [PTR_WIDTH-1:0] full_check_mask;
        input [PTR_WIDTH-1:0] rptr_gray;
        reg [PTR_WIDTH-1:0] mask;
        begin
            // Invert MSB and next MSB bits, keep others same
            mask = rptr_gray;
            mask[PTR_WIDTH-1]   = ~rptr_gray[PTR_WIDTH-1];
            mask[PTR_WIDTH-2]   = ~rptr_gray[PTR_WIDTH-2];
            full_check_mask = mask;
        end
    endfunction

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !full_condition) begin
            wptr_bin <= wptr_bin + 1'b1;
        end
    end

    // Read pointer logic
    wire empty_condition = (rptr_gray == wptr_gray_rclk_sync2);
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc && !rempty ? 1'b1 : 1'b0);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (rinc && !empty_condition) begin
            rptr_bin <= rptr_bin + 1'b1;
        end
    end

    // Assign full and empty outputs
    assign wfull = full_condition;
    assign rempty = empty_condition;

    // RAM addressing: use lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write and read enables to RAM
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;

    // RAM read data output
    wire [WIDTH-1:0] ram_rdata;

    // Register output data on read clock for stability
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (r_en)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

    // Instantiate dual-port RAM submodule
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
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]         wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
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