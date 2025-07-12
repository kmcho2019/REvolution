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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1; // extra bit for wrap detection

    // -------------------------------
    // Gray code utility functions
    // -------------------------------
    function automatic [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    // Convert Gray code to binary for addressing RAM
    function automatic [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    // -------------------------------
    // Write Pointer (Gray-coded)
    // -------------------------------
    reg [PTR_WIDTH-1:0] wptr_gray, wptr_gray_next;
    reg [PTR_WIDTH-1:0] wptr_gray_bin; // binary for increment and addressing

    // Write pointer binary for increment and conversion
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            wptr_gray_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_gray_bin <= wptr_gray_bin + 1;
        end
    end

    always @(*) begin
        wptr_gray_next = bin2gray(wptr_gray_bin);
    end

    // Register Gray-coded write pointer
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn)
            wptr_gray <= 0;
        else
            wptr_gray <= wptr_gray_next;
    end

    // -------------------------------
    // Read Pointer (Gray-coded)
    // -------------------------------
    reg [PTR_WIDTH-1:0] rptr_gray, rptr_gray_next;
    reg [PTR_WIDTH-1:0] rptr_gray_bin;

    // Read pointer binary for increment and addressing
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rptr_gray_bin <= 0;
        end else if (rinc && !rempty) begin
            rptr_gray_bin <= rptr_gray_bin + 1;
        end
    end

    always @(*) begin
        rptr_gray_next = bin2gray(rptr_gray_bin);
    end

    // Register Gray-coded read pointer
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rptr_gray <= 0;
        else
            rptr_gray <= rptr_gray_next;
    end

    // -------------------------------
    // Synchronizers
    // -------------------------------

    // Synchronize read pointer into write clock domain (two-stage)
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync_0, rptr_gray_wclk_sync_1;
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            rptr_gray_wclk_sync_0 <= 0;
            rptr_gray_wclk_sync_1 <= 0;
        end else begin
            rptr_gray_wclk_sync_0 <= rptr_gray;
            rptr_gray_wclk_sync_1 <= rptr_gray_wclk_sync_0;
        end
    end

    // Synchronize write pointer into read clock domain (two-stage)
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync_0, wptr_gray_rclk_sync_1;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            wptr_gray_rclk_sync_0 <= 0;
            wptr_gray_rclk_sync_1 <= 0;
        end else begin
            wptr_gray_rclk_sync_0 <= wptr_gray;
            wptr_gray_rclk_sync_1 <= wptr_gray_rclk_sync_0;
        end
    end

    wire [PTR_WIDTH-1:0] rptr_gray_wclk_sync = rptr_gray_wclk_sync_1;
    wire [PTR_WIDTH-1:0] wptr_gray_rclk_sync = wptr_gray_rclk_sync_1;

    // -------------------------------
    // Full and Empty Detection
    // -------------------------------
    // FIFO is empty when read and synchronized write pointers match
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

    // FIFO is full when write pointer is one ahead of read pointer with inverted top 2 bits
    // i.e. wptr == {~rptr[PTR_WIDTH-1], ~rptr[PTR_WIDTH-2], rptr[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_gray_wclk_inv_top2;
    assign rptr_gray_wclk_inv_top2 = { ~rptr_gray_wclk_sync[PTR_WIDTH-1],
                                       ~rptr_gray_wclk_sync[PTR_WIDTH-2],
                                       rptr_gray_wclk_sync[PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray == rptr_gray_wclk_inv_top2);

    // -------------------------------
    // RAM address calculation (binary)
    // -------------------------------
    wire [PTR_WIDTH-1:0] wptr_bin_for_addr = gray2bin(wptr_gray);
    wire [PTR_WIDTH-1:0] rptr_bin_for_addr = gray2bin(rptr_gray);

    wire [ADDR_WIDTH-1:0] waddr = wptr_bin_for_addr[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin_for_addr[ADDR_WIDTH-1:0];

    // -------------------------------
    // RAM signals
    // -------------------------------
    wire w_en = winc & (~wfull);
    wire r_en = rinc & (~rempty);

    wire [WIDTH-1:0] rdata_ram;

    // -------------------------------
    // Dual port RAM instantiation
    // -------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(rdata_ram)
    );

    // Register output data to align with read clock domain timing
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            rdata <= {WIDTH{1'b0}};
        end else if (r_en) begin
            rdata <= rdata_ram;
        end
    end

endmodule


// -----------------------------------------------------------------
// Dual Port RAM with Separate Read and Write Clocks & Enables
// -----------------------------------------------------------------
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

    // RAM memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: on wclk rising edge and if write enable asserted
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port: on rclk rising edge, if read enable asserted, read data out
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule