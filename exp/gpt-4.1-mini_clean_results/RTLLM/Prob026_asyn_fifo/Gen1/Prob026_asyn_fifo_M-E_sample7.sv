`timescale 1ns/1ps

// Gray code conversion functions and synchronizer module
module gray_sync #(
    parameter WIDTH = 5
) (
    input  wire                 clk,
    input  wire                 reset_n,
    input  wire [WIDTH-1:0]     async_in,
    output reg  [WIDTH-1:0]     sync_out
);

    reg [WIDTH-1:0] sync_1;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sync_1   <= {WIDTH{1'b0}};
            sync_out <= {WIDTH{1'b0}};
        end else begin
            sync_1   <= async_in;
            sync_out <= sync_1;
        end
    end
endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                  wclk,
    input  wire                  rclk,
    input  wire                  wrstn,
    input  wire                  rrstn,
    input  wire                  winc,
    input  wire                  rinc,
    input  wire [WIDTH-1:0]      wdata,
    output wire                  wfull,
    output wire                  rempty,
    output wire [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    //----------------------------------------------------------------------------
    // Binary to Gray and Gray to Binary conversion functions
    //----------------------------------------------------------------------------

    // Binary to Gray
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray to Binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH - 2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i + 1] ^ gray[i];
        end
    endfunction

    //----------------------------------------------------------------------------
    // Write domain pointer logic
    //----------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            if (winc && !wfull) begin
                wptr_bin  <= wptr_bin + 1'b1;
                wptr_gray <= bin2gray(wptr_bin + 1'b1);
            end else begin
                wptr_bin  <= wptr_bin;
                wptr_gray <= wptr_gray;
            end
        end
    end

    //----------------------------------------------------------------------------
    // Read domain pointer logic
    //----------------------------------------------------------------------------
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            if (rinc && !rempty) begin
                rptr_bin  <= rptr_bin + 1'b1;
                rptr_gray <= bin2gray(rptr_bin + 1'b1);
            end else begin
                rptr_bin  <= rptr_bin;
                rptr_gray <= rptr_gray;
            end
        end
    end

    //----------------------------------------------------------------------------
    // Synchronize pointers across domains
    //----------------------------------------------------------------------------

    wire [PTR_WIDTH-1:0] rptr_gray_wclk; // Read pointer synchronized into wclk domain
    wire [PTR_WIDTH-1:0] wptr_gray_rclk; // Write pointer synchronized into rclk domain

    gray_sync #(PTR_WIDTH) rptr_sync_inst (
        .clk(wclk),
        .reset_n(wrstn),
        .async_in(rptr_gray),
        .sync_out(rptr_gray_wclk)
    );

    gray_sync #(PTR_WIDTH) wptr_sync_inst (
        .clk(rclk),
        .reset_n(rrstn),
        .async_in(wptr_gray),
        .sync_out(wptr_gray_rclk)
    );

    //----------------------------------------------------------------------------
    // Convert synchronized Gray pointers back to binary for addressing
    //----------------------------------------------------------------------------
    wire [PTR_WIDTH-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk);

    // RAM addresses are lower bits of pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    //----------------------------------------------------------------------------
    // Full and empty flag generation
    // FIFO full when:
    // wptr_gray == {~rptr_gray_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_wclk[PTR_WIDTH-3:0]}
    // FIFO empty when:
    // rptr_gray == wptr_gray_rclk
    //----------------------------------------------------------------------------

    assign wfull = (wptr_gray == {~rptr_gray_wclk[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray_wclk[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_rclk);

    //----------------------------------------------------------------------------
    // RAM interface signals
    //----------------------------------------------------------------------------
    wire w_en = winc && !wfull;
    // Read enable is not needed explicitly for RAM because read data is always available at read address.
    // Read address changes on rinc and when not empty, so we gate increments for safety.
    wire r_en = rinc && !rempty;

    //----------------------------------------------------------------------------
    // Instantiate dual-port RAM
    //----------------------------------------------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


//----------------------------------------------------------------------------
// Dual-port RAM behavioral model
// Read port is asynchronous read (read data updates whenever raddr changes)
// This simplifies the FIFO read logic (no explicit read enable needed).
//----------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                  wclk,
    input  wire                  wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]      wdata,
    input  wire                  rclk, // rclk used for synchronous read domain usage (for full async read, rclk unused)
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]      rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port synchronous to wclk
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port synchronous to rclk - outputs data corresponding to raddr
    always @(posedge rclk) begin
        rdata <= mem[raddr];
    end

endmodule