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
    input  [WIDTH-1:0]      wdata,      // Write data
    output                  wfull,      // FIFO full flag (write domain)
    output                  rempty,     // FIFO empty flag (read domain)
    output [WIDTH-1:0]      rdata       // Read data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ----- Binary pointers -----
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // ----- Gray code pointers -----
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // ----- Synchronizers -----
    // Synchronize read pointer to write clock domain
    wire [PTR_WIDTH-1:0] rptr_gray_wclk;
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_rptr_to_wclk (
        .clk(wclk),
        .rstn(wrstn),
        .async_in(rptr_gray),
        .sync_out(rptr_gray_wclk)
    );

    // Synchronize write pointer to read clock domain
    wire [PTR_WIDTH-1:0] wptr_gray_rclk;
    gray_sync #(.WIDTH(PTR_WIDTH)) sync_wptr_to_rclk (
        .clk(rclk),
        .rstn(rrstn),
        .async_in(wptr_gray),
        .sync_out(wptr_gray_rclk)
    );

    // ----- Convert synchronized Gray pointers back to binary -----
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_rclk);

    // ----- Write logic -----
    // Calculate next write pointer (binary)
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;

    // Full condition combinational (based on gray code pointer difference)
    wire full_condition = 
        ( (wptr_gray_next_bit(wptr_bin_next, rptr_gray_wclk)) );

    // Function to check full condition based on Gray code pointers
    // per problem spec: when write pointer has one more cycle than read pointer,
    // highest and second-highest bits inverted, rest equal
    function wptr_gray_next_bit;
        input [PTR_WIDTH-1:0] wptr_bin_nxt;
        input [PTR_WIDTH-1:0] rptr_gray_sync;
        reg [PTR_WIDTH-1:0] wptr_gray_nxt;
        begin
            wptr_gray_nxt = bin2gray(wptr_bin_nxt);
            wptr_gray_next_bit = (
                (wptr_gray_nxt[PTR_WIDTH-1]   == ~rptr_gray_sync[PTR_WIDTH-1]) &&
                (wptr_gray_nxt[PTR_WIDTH-2]   == ~rptr_gray_sync[PTR_WIDTH-2]) &&
                (wptr_gray_nxt[PTR_WIDTH-3:0] == rptr_gray_sync[PTR_WIDTH-3:0])
            );
        end
    endfunction

    // Write pointer update on wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= {PTR_WIDTH{1'b0}};
        end else if (winc && !full_condition) begin
            wptr_bin <= wptr_bin_next;
        end
    end

    // ----- Read logic -----
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + 1'b1;

    // Empty condition combinational: true if read pointer Gray == synchronized write pointer Gray
    wire empty_condition = (rptr_gray == wptr_gray_rclk);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= {PTR_WIDTH{1'b0}};
        end else if (rinc && !empty_condition) begin
            rptr_bin <= rptr_bin_next;
        end
    end

    // ----- Flags -----
    assign wfull = full_condition;
    assign rempty = empty_condition;

    // ----- RAM interface -----
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire w_en = winc && !wfull;
    wire r_en = rinc && !rempty;
    wire [WIDTH-1:0] ram_rdata;

    // Register read data output on rclk for stable output
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (r_en)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

    // ----- Instantiate dual-port RAM -----
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    // ------------------------
    // Gray code conversion functions
    // ------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                bin2gray[i] = bin[i+1] ^ bin[i];
            end
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i=PTR_WIDTH-2; i>=0; i=i-1) begin
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
            end
        end
    endfunction

endmodule


// ----------------------------
// Dual-port RAM: separate read and write ports with independent clocks and enables
// ----------------------------
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


// ----------------------------
// Gray code synchronizer module: double flop synchronizer for Gray-coded pointer crossing clock domains
// ----------------------------
module gray_sync #(
    parameter WIDTH = 5
)(
    input                  clk,
    input                  rstn,       // Active low reset
    input  [WIDTH-1:0]     async_in,
    output [WIDTH-1:0]     sync_out
);
    reg [WIDTH-1:0] sync_0;
    reg [WIDTH-1:0] sync_1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_0 <= {WIDTH{1'b0}};
            sync_1 <= {WIDTH{1'b0}};
        end else begin
            sync_0 <= async_in;
            sync_1 <= sync_0;
        end
    end

    assign sync_out = sync_1;

endmodule