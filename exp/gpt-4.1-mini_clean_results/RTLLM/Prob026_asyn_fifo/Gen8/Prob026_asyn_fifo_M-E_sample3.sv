`timescale 1ns / 1ps

// Dual-port RAM with independent write/read clocks and enables
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

    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    // Write port: synchronous write on wclk when wenc asserted
    always @(posedge wclk) begin
        if (wenc) ram_mem[waddr] <= wdata;
    end

    // Read port: synchronous read on rclk when renc asserted
    // Data held stable otherwise
    always @(posedge rclk) begin
        if (renc)
            rdata <= ram_mem[raddr];
    end

endmodule

// Two-stage synchronizer for Gray coded pointer crossing clock domains
module sync_stage2 #(
    parameter WIDTH = 5
)(
    input  wire             clk,
    input  wire             rst_n, // asynchronous active low reset
    input  wire [WIDTH-1:0] data_in,
    output reg  [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] sync_ff;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff  <= {WIDTH{1'b0}};
            data_out <= {WIDTH{1'b0}};
        end else begin
            sync_ff  <= data_in;
            data_out <= sync_ff;
        end
    end
endmodule


// Combinational Gray code encoder for parameterized width
module gray_encoder #(
    parameter WIDTH = 5
)(
    input  wire [WIDTH-1:0] bin,
    output reg  [WIDTH-1:0] gray
);
    integer i;
    always @(*) begin
        gray[WIDTH-1] = bin[WIDTH-1];
        for (i = WIDTH-2; i >= 0; i = i - 1)
            gray[i] = bin[i+1] ^ bin[i];
    end
endmodule


// Main asynchronous FIFO module
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input  wire               wclk,
    input  wire               rclk,
    input  wire               wrstn,  // active low async reset write domain
    input  wire               rrstn,  // active low async reset read domain
    input  wire               winc,   // write increment (push)
    input  wire               rinc,   // read increment (pop)
    input  wire [WIDTH-1:0]   wdata,  // write data
    output reg                wfull,  // FIFO full flag
    output reg                rempty, // FIFO empty flag
    output wire [WIDTH-1:0]   rdata   // read data
);

    // Binary pointers (write and read domains)
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray encoded pointers
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] rptr_gray;

    // Synchronized pointers into opposite clock domains
    wire [PTR_WIDTH-1:0] rptr_gray_sync_wclk;
    wire [PTR_WIDTH-1:0] wptr_gray_sync_rclk;

    // Instantiate Gray encoder combinational modules
    gray_encoder #(.WIDTH(PTR_WIDTH)) gray_enc_w (.bin(wptr_bin), .gray(wptr_gray));
    gray_encoder #(.WIDTH(PTR_WIDTH)) gray_enc_r (.bin(rptr_bin), .gray(rptr_gray));

    // Synchronize read pointer (gray) into write clock domain
    sync_stage2 #(.WIDTH(PTR_WIDTH)) sync_rptr_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .data_in(rptr_gray),
        .data_out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer (gray) into read clock domain
    sync_stage2 #(.WIDTH(PTR_WIDTH)) sync_wptr_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .data_in(wptr_gray),
        .data_out(wptr_gray_sync_rclk)
    );

    // Extract address bits for RAM from binary pointers (lowest ADDR_WIDTH bits)
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Generate write enable: write only when not full and winc asserted
    wire wen = winc & ~wfull;

    // Generate read enable: read only when not empty and rinc asserted
    wire ren = rinc & ~rempty;

    // Dual-port RAM instance
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dp_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write pointer binary counter (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (wen)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Read pointer binary counter (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (ren)
            rptr_bin <= rptr_bin + 1'b1;
    end

    // Helper function: Compare if pointers are equal (Gray code)
    function pointer_equal;
        input [PTR_WIDTH-1:0] p1;
        input [PTR_WIDTH-1:0] p2;
        begin
            pointer_equal = (p1 == p2);
        end
    endfunction

    // Helper function: FIFO full detection logic:
    // Full when write pointer is one behind read pointer, accounting for circular wrap.
    // We detect full condition by checking if the next write pointer Gray code equals
    // the synchronized read pointer Gray code with top two bits inverted.
    // This matches the classical asynchronous FIFO full detection.
    // Instead of bitwise inversion, implement by checking if (wptr_bin + 1) has MSB bits toggled compared to rptr_gray_sync_wclk.
    // For simplicity, calculate next write pointer Gray code in combinational logic.

    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;

    wire [PTR_WIDTH-1:0] wptr_gray_next;
    gray_encoder #(.WIDTH(PTR_WIDTH)) gray_enc_w_next (.bin(wptr_bin_next), .gray(wptr_gray_next));

    // Create inverted MSB bits of synchronized read pointer
    wire [PTR_WIDTH-1:0] rptr_inv_msb = {
        ~rptr_gray_sync_wclk[PTR_WIDTH-1],
        ~rptr_gray_sync_wclk[PTR_WIDTH-2],
        rptr_gray_sync_wclk[PTR_WIDTH-3:0]
    };

    // Full occurs if next write pointer equals read pointer with MSB bits inverted
    wire full_flag = (wptr_gray_next == rptr_inv_msb);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 1'b0;
        else
            wfull <= full_flag;
    end

    // Empty detection: FIFO empty if read pointer equals synchronized write pointer
    wire empty_flag = (rptr_gray == wptr_gray_sync_rclk);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1'b1; // Empty after reset
        else
            rempty <= empty_flag;
    end

endmodule