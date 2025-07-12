`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,
    input                    rclk,
    input                    wrstn,     // active low reset for write domain
    input                    rrstn,     // active low reset for read domain
    input                    winc,      // write increment enable
    input                    rinc,      // read increment enable
    input      [WIDTH-1:0]   wdata,     // write data input
    output                   wfull,     // FIFO full flag
    output                   rempty,    // FIFO empty flag
    output reg [WIDTH-1:0]   rdata      // read data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ------------------------------------------------------------------------
    // Dual-port RAM instantiation: stores FIFO data with separate read/write ports
    // ------------------------------------------------------------------------
    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wfull ? 1'b0 : winc),  // mask write enable when full
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rempty ? 1'b0 : rinc), // mask read enable when empty
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // ------------------------------------------------------------------------
    // Function: binary to Gray code
    // ------------------------------------------------------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // ------------------------------------------------------------------------
    // Function: Gray code to binary (for synchronization verification if needed)
    // ------------------------------------------------------------------------
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i -1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

    // ------------------------------------------------------------------------
    // Write pointer binary register and next pointer logic
    // ------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_gray;

    assign wptr_bin_next = wptr_bin + ((winc && !wfull) ? 1'b1 : 1'b0);
    assign wptr_gray = bin2gray(wptr_bin_next);
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    // ------------------------------------------------------------------------
    // Read pointer binary register and next pointer logic
    // ------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_gray;

    assign rptr_bin_next = rptr_bin + ((rinc && !rempty) ? 1'b1 : 1'b0);
    assign rptr_gray = bin2gray(rptr_bin_next);
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    // ------------------------------------------------------------------------
    // Synchronize read pointer (Gray) into write clock domain (two-stage synchronizer)
    // ------------------------------------------------------------------------
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

    // ------------------------------------------------------------------------
    // Synchronize write pointer (Gray) into read clock domain (two-stage synchronizer)
    // ------------------------------------------------------------------------
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

    // ------------------------------------------------------------------------
    // FIFO Full logic: write domain
    // Full if MSB and next MSB inverted and lower bits equal (Gray pointers)
    // ------------------------------------------------------------------------
    wire full_msb_inverted = (wptr_gray[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_gray_sync2_wclk[PTR_WIDTH-1:PTR_WIDTH-2]);
    wire full_lower_equal  = (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync2_wclk[PTR_WIDTH-3:0]);
    assign wfull = full_msb_inverted && full_lower_equal;

    // ------------------------------------------------------------------------
    // FIFO Empty logic: read domain
    // Empty if read and synchronized write pointers are equal (Gray pointers)
    // ------------------------------------------------------------------------
    assign rempty = (rptr_gray == wptr_gray_sync2_rclk);

    // ------------------------------------------------------------------------
    // Read Data Register: latch RAM data on read enable
    // ------------------------------------------------------------------------
    wire read_enable = rinc && !rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (read_enable)
            rdata <= ram_rdata;
    end

endmodule


// ------------------------------------------------------------------------
// Dual-Port RAM module definition as specified
// ------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
    integer i;

    // Write logic
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read logic
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= {WIDTH{1'b0}};  // optional: data is zero if no read
    end

endmodule