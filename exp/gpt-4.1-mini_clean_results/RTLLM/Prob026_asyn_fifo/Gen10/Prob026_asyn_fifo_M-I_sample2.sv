`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // Active low write domain reset
    input                   rrstn,      // Active low read domain reset
    input                   winc,       // Write increment (write enable)
    input                   rinc,       // Read increment (read enable)
    input  [WIDTH-1:0]      wdata,      // Write data input
    output                  wfull,      // FIFO full flag (write domain)
    output                  rempty,     // FIFO empty flag (read domain)
    output [WIDTH-1:0]      rdata       // Read data output
);

    // Calculate address width and pointer width (extra bit for full detection)
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // --- Binary pointers ---
    reg [PTR_WIDTH-1:0] wptr_bin;      // Write pointer binary
    reg [PTR_WIDTH-1:0] rptr_bin;      // Read pointer binary

    // --- Gray code pointers ---
    wire [PTR_WIDTH-1:0] wptr_gray = bin_to_gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin_to_gray(rptr_bin);

    // --- Synchronizers ---
    wire [PTR_WIDTH-1:0] rptr_gray_wclk;  // Read pointer synchronized into write clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_rclk;  // Write pointer synchronized into read clock domain

    gray_sync #(
        .WIDTH(PTR_WIDTH)
    ) sync_rptr_to_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .async_in(rptr_gray),
        .sync_out(rptr_gray_wclk)
    );

    gray_sync #(
        .WIDTH(PTR_WIDTH)
    ) sync_wptr_to_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .async_in(wptr_gray),
        .sync_out(wptr_gray_rclk)
    );

    // --- Convert synchronized Gray pointers back to binary ---
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray_to_bin(rptr_gray_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray_to_bin(wptr_gray_rclk);

    // --- Full condition ---
    // FIFO full when:
    // write pointer MSBs inverted wrt read pointer MSBs and lower bits equal
    wire full = ( (wptr_gray[PTR_WIDTH-1]     != rptr_gray_wclk[PTR_WIDTH-1]) &&
                  (wptr_gray[PTR_WIDTH-2]     != rptr_gray_wclk[PTR_WIDTH-2]) &&
                  (wptr_gray[PTR_WIDTH-3:0]  == rptr_gray_wclk[PTR_WIDTH-3:0]) );

    // --- Empty condition ---
    wire empty = (rptr_gray == wptr_gray_rclk);

    // --- Next pointer increments ---
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + 1'b1;

    // --- Write pointer update ---
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= {PTR_WIDTH{1'b0}};
        else if (winc && !full)
            wptr_bin <= wptr_bin_next;
    end

    // --- Read pointer update ---
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= {PTR_WIDTH{1'b0}};
        else if (rinc && !empty)
            rptr_bin <= rptr_bin_next;
    end

    // --- Assign output flags ---
    assign wfull = full;
    assign rempty = empty;

    // --- RAM control signals ---
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire w_en = winc && !full;
    wire r_en = rinc && !empty;

    wire [WIDTH-1:0] ram_rdata;

    // Register read data output, valid when reading (r_en)
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (!rrstn)
            rdata_reg <= {WIDTH{1'b0}};
        else if (r_en)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

    // --- Instantiate uniquely named dual-port RAM module ---
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

    // --- Gray code conversion (combinational) ---
    function [PTR_WIDTH-1:0] bin_to_gray(input [PTR_WIDTH-1:0] bin);
        begin
            // Gray code MSB = MSB of binary
            // Each lower bit = XOR of binary bit and next higher bit
            bin_to_gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (integer i = PTR_WIDTH-2; i >= 0; i = i -1) begin
                bin_to_gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    function [PTR_WIDTH-1:0] gray_to_bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            // Binary MSB = Gray MSB
            gray_to_bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            // Each binary bit = XOR of next higher binary bit and current gray bit
            for (i = PTR_WIDTH-2; i >= 0; i = i -1) begin
                gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
            end
        end
    endfunction

endmodule


// -----------------------------------------
// Renamed dual-port RAM module to avoid conflicts
// Asynchronous dual-port RAM with separate clocks for read and write
// -----------------------------------------
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


// -----------------------------------------
// Gray code pointer synchronizer module
// Double-flop synchronizer for Gray-coded asynchronous pointer crossing clock domains
// -----------------------------------------
module gray_sync #(
    parameter WIDTH = 5
)(
    input                  clk,
    input                  rstn,
    input  [WIDTH-1:0]     async_in,
    output reg [WIDTH-1:0] sync_out
);
    reg [WIDTH-1:0] sync_0;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_0   <= {WIDTH{1'b0}};
            sync_out <= {WIDTH{1'b0}};
        end else begin
            sync_0   <= async_in;
            sync_out <= sync_0;
        end
    end
endmodule