`timescale 1ns / 1ps

// Dual-port RAM with separate read/write clocks and enables
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                   wclk,
    input  wire                   wenc,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]       wdata,
    input  wire                   rclk,
    input  wire                   renc,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]       rdata
);
    // RAM storage
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port: write synchronous to wclk
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read port: read synchronous to rclk, output updated only when renc asserted
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule


// Two-stage synchronizer for Gray-coded pointer crossing clock domains
module ptr_sync_gray #(
    parameter WIDTH = 5
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire [WIDTH-1:0] data_in,
    output reg  [WIDTH-1:0] data_out
);

    reg [WIDTH-1:0] sync_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_stage1 <= {WIDTH{1'b0}};
            data_out   <= {WIDTH{1'b0}};
        end else begin
            sync_stage1 <= data_in;
            data_out   <= sync_stage1;
        end
    end

endmodule


// Asynchronous FIFO using dual-port RAM and Gray code pointer synchronization
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,    // active low synchronous reset write domain
    input  wire                 rrstn,    // active low synchronous reset read domain
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output reg                  wfull,
    output reg                  rempty,
    output wire [WIDTH-1:0]     rdata
);

    // Binary write pointer (PTR_WIDTH bits)
    reg [PTR_WIDTH-1:0] wptr_bin;
    // Gray code write pointer
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Binary read pointer (PTR_WIDTH bits)
    reg [PTR_WIDTH-1:0] rptr_bin;
    // Gray code read pointer
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronized pointers crossing clock domains
    wire [PTR_WIDTH-1:0] rptr_gray_wclk; // rptr synchronized into wclk domain
    wire [PTR_WIDTH-1:0] wptr_gray_rclk; // wptr synchronized into rclk domain

    // Convert binary to Gray code function
    function automatic [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    // Convert Gray code to binary function
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

    // Write enable: only if not full and winc asserted
    wire wen = winc & ~wfull;

    // Write pointer logic (write clock domain)
    always @(posedge wclk) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read enable: only if not empty and rinc asserted
    wire ren = rinc & ~rempty;

    // Read pointer logic (read clock domain)
    always @(posedge rclk) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer into write clock domain
    ptr_sync_gray #(
        .WIDTH(PTR_WIDTH)
    ) sync_rptr_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .data_in(rptr_gray),
        .data_out(rptr_gray_wclk)
    );

    // Synchronize write pointer into read clock domain
    ptr_sync_gray #(
        .WIDTH(PTR_WIDTH)
    ) sync_wptr_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .data_in(wptr_gray),
        .data_out(wptr_gray_rclk)
    );

    // RAM addresses for write and read (lower ADDR_WIDTH bits of binary pointers)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // FIFO full logic in write clock domain:
    // Full if next write pointer equals read pointer with top two bits inverted
    wire [PTR_WIDTH-1:0] rptr_gray_wclk_inv = { ~rptr_gray_wclk[PTR_WIDTH-1],
                                               ~rptr_gray_wclk[PTR_WIDTH-2],
                                                rptr_gray_wclk[PTR_WIDTH-3:0] };
    wire full_next = (wptr_gray == rptr_gray_wclk_inv);

    always @(posedge wclk) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_next;
    end

    // FIFO empty logic in read clock domain:
    wire empty_next = (rptr_gray == wptr_gray_rclk);

    always @(posedge rclk) begin
        if (!rrstn)
            rempty <= 1'b1; // FIFO empty on reset
        else
            rempty <= empty_next;
    end

endmodule