`timescale 1ns / 1ps
`default_nettype none

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,   // active low reset for write domain
    input  wire                 rrstn,   // active low reset for read domain
    input  wire                 winc,    // write increment enable
    input  wire                 rinc,    // read increment enable
    input  wire [WIDTH-1:0]     wdata,   // write data input
    output wire                 wfull,   // write full flag
    output wire                 rempty,  // read empty flag
    output wire [WIDTH-1:0]     rdata    // read data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1; // Extra bit for full/empty distinction

    // Binary pointers (write and read) in their respective clock domains
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + ((winc && !wfull) ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + ((rinc && !rempty) ? 1'b1 : 1'b0);

    // Automatic Gray code conversion functions

    function automatic [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] b);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = b[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin2gray[i] = b[i+1] ^ b[i];
        end
    endfunction

    function automatic [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] g);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = g[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ g[i];
        end
    endfunction

    // Gray pointers in write and read domains
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronize read pointer Gray code into write clock domain (2-stage registers)
    reg [PTR_WIDTH-1:0] rptr_gray_sync_wclk1, rptr_gray_sync_wclk2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_sync_wclk2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_sync_wclk1 <= rptr_gray;
            rptr_gray_sync_wclk2 <= rptr_gray_sync_wclk1;
        end
    end

    // Synchronize write pointer Gray code into read clock domain (2-stage registers)
    reg [PTR_WIDTH-1:0] wptr_gray_sync_rclk1, wptr_gray_sync_rclk2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_sync_rclk2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_sync_rclk1 <= wptr_gray;
            wptr_gray_sync_rclk2 <= wptr_gray_sync_rclk1;
        end
    end

    // Convert synchronized Gray pointers back to binary for full/empty logic
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk2);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk2);

    // Full logic:
    // FIFO is full when:
    // - write pointer's MSB and next MSB are inverted compared to read pointer's
    // - the rest of the bits are equal
    wire full_flag = ( (wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_sync_wclk2[PTR_WIDTH-1]) &&
                       (wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_sync_wclk2[PTR_WIDTH-2]) &&
                       (wptr_gray[PTR_WIDTH-3:0] ==  rptr_gray_sync_wclk2[PTR_WIDTH-3:0]) );

    // Empty logic:
    // FIFO is empty when read pointer equals synchronized write pointer
    wire empty_flag = (rptr_gray == wptr_gray_sync_rclk2);

    assign wfull  = full_flag;
    assign rempty = empty_flag;

    // Sequential pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else
            wptr_bin <= wptr_bin_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else
            rptr_bin <= rptr_bin_next;
    end

    // Extract address bits for RAM (lower ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // RAM write and read enable signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Instantiate dual-port RAM module (assumed implemented elsewhere)
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // Output read data from RAM
    assign rdata = ram_rdata;

endmodule

`default_nettype wire