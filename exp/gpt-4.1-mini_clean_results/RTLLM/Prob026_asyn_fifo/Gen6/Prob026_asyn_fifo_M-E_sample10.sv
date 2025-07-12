`timescale 1ns / 1ps

// Dual-port RAM module with independent clocks for write and read ports.
// Parameterized data width and depth.
module async_dp_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                  wclk,
    input  wire                  wren,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,
    input  wire                  rclk,
    input  wire                  rren,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write Port
    always @(posedge wclk) begin
        if (wren) begin
            mem[waddr] <= wdata;
        end
    end

    // Read Port
    always @(posedge rclk) begin
        if (rren) begin
            rdata <= mem[raddr];
        end else begin
            rdata <= rdata; // Hold previous value when no read enable
        end
    end

endmodule

// Two-stage synchronizer for multi-bit signals crossing clock domains.
module sync_gray #(
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

// Main asynchronous FIFO module
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1   // Pointer width (binary and Gray)
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,    // Write side reset (active low)
    input  wire                 rrstn,    // Read side reset (active low)
    input  wire                 winc,     // Write increment (push) request
    input  wire                 rinc,     // Read increment (pop) request
    input  wire [WIDTH-1:0]     wdata,    // Data input to FIFO
    output reg                  wfull,    // FIFO full signal (write domain)
    output reg                  rempty,   // FIFO empty signal (read domain)
    output wire [WIDTH-1:0]     rdata     // Data output from FIFO
);

    // Internal binary write and read pointers
    reg [PTR_WIDTH-1:0] wptr_bin;   // Write pointer (binary)
    reg [PTR_WIDTH-1:0] rptr_bin;   // Read pointer (binary)

    // Corresponding Gray code pointers
    reg [PTR_WIDTH-1:0] wptr_gray;  // Write pointer (Gray)
    reg [PTR_WIDTH-1:0] rptr_gray;  // Read pointer (Gray)

    // Synchronized pointers across clock domains
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk; // Read pointer synchronized into write clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk; // Write pointer synchronized into read clock domain

    // Convert binary pointer to Gray code
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Convert Gray code to binary pointer
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
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

    // Write pointer increment logic (write clock domain)
    wire wfull_next;
    wire wen = winc && !wfull;    // Write enable only if not full

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    // Read pointer increment logic (read clock domain)
    wire ren = rinc && !rempty;   // Read enable only if not empty

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    // Synchronize read pointer (Gray) into write clock domain
    sync_gray #(
        .WIDTH(PTR_WIDTH)
    ) sync_rptr_inst (
        .clk(wclk),
        .rst_n(wrstn),
        .data_in(rptr_gray),
        .data_out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer (Gray) into read clock domain
    sync_gray #(
        .WIDTH(PTR_WIDTH)
    ) sync_wptr_inst (
        .clk(rclk),
        .rst_n(rrstn),
        .data_in(wptr_gray),
        .data_out(wptr_gray_sync_rclk)
    );

    // Extract RAM addresses from binary pointers (lower ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate the dual-port RAM
    async_dp_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wren(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .rren(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Determine full condition in write clock domain
    // FIFO full when write pointer is one cycle ahead of read pointer with inverted MSB bits
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk_inv;
    assign rptr_gray_sync_wclk_inv = {
        ~rptr_gray_sync_wclk[PTR_WIDTH-1],
        ~rptr_gray_sync_wclk[PTR_WIDTH-2],
        rptr_gray_sync_wclk[PTR_WIDTH-3:0]
    };

    wire full_condition = (wptr_gray == rptr_gray_sync_wclk_inv);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_condition;
    end

    // Determine empty condition in read clock domain
    wire empty_condition = (rptr_gray == wptr_gray_sync_rclk);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1;
        else
            rempty <= empty_condition;
    end

endmodule