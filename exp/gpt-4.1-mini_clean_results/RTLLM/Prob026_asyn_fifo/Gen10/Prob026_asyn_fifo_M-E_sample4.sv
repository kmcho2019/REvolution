`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // active low reset for write domain
    input                   rrstn,   // active low reset for read domain
    input                   winc,    // write enable (increment)
    input                   rinc,    // read enable (increment)
    input  [WIDTH-1:0]      wdata,   // write data
    output                  wfull,   // write full flag
    output                  rempty,  // read empty flag
    output [WIDTH-1:0]      rdata    // read data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ------------------------------
    // Binary pointers in each domain
    // ------------------------------

    // Write pointer binary counter
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc && !wfull ? 1'b1 : 1'b0);

    // Read pointer binary counter
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc && !rempty ? 1'b1 : 1'b0);

    // ------------------------------
    // Gray code conversion functions
    // ------------------------------
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] b);
        integer i;
        begin
            bin2gray[PTR_WIDTH-1] = b[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1)
                bin2gray[i] = b[i+1] ^ b[i];
        end
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] g);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = g[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ g[i];
        end
    endfunction

    // Current Gray pointers
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // -----------------------------------
    // Synchronizers for pointer crossing
    // -----------------------------------

    // Synchronize read pointer Gray code into write clock domain (2-stage flip-flops)
    reg [PTR_WIDTH-1:0] rptr_gray_sync_wclk1, rptr_gray_sync_wclk2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk1 <= 0;
            rptr_gray_sync_wclk2 <= 0;
        end else begin
            rptr_gray_sync_wclk1 <= rptr_gray;
            rptr_gray_sync_wclk2 <= rptr_gray_sync_wclk1;
        end
    end

    // Synchronize write pointer Gray code into read clock domain (2-stage flip-flops)
    reg [PTR_WIDTH-1:0] wptr_gray_sync_rclk1, wptr_gray_sync_rclk2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk1 <= 0;
            wptr_gray_sync_rclk2 <= 0;
        end else begin
            wptr_gray_sync_rclk1 <= wptr_gray;
            wptr_gray_sync_rclk2 <= wptr_gray_sync_rclk1;
        end
    end

    // ----------------------------------
    // Convert synchronized Gray to binary
    // ----------------------------------
    wire [PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk2);
    wire [PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk2);

    // -------------------------------
    // Full and Empty logic (combinational)
    // -------------------------------

    // FIFO Full Condition:
    // Write pointer is "one ahead" of read pointer with MSB inverted as per problem description:
    // When write pointer has one cycle more RAM than read pointer,
    // highest and second highest bits differ (inverted), remaining bits are equal
    wire full_flag;
    assign full_flag = (
        (wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_sync_wclk2[PTR_WIDTH-1]) &&
        (wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_sync_wclk2[PTR_WIDTH-2]) &&
        (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync_wclk2[PTR_WIDTH-3:0])
    );

    // FIFO Empty Condition:
    // When read pointer equals synchronized write pointer
    wire empty_flag;
    assign empty_flag = (rptr_gray == wptr_gray_sync_rclk2);

    assign wfull = full_flag;
    assign rempty = empty_flag;

    // -------------------------------
    // Pointer update sequential logic
    // -------------------------------

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    // -------------------------------
    // Extract RAM addresses from binary pointers (lowest bits)
    // -------------------------------
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write and read enables for RAM
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // -------------------------------
    // Instantiate dual-port RAM module
    // -------------------------------
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

    // Directly assign RAM output to rdata (no additional register)
    assign rdata = ram_rdata;

endmodule


// ------------------------------------------------------------------
// Dual-port RAM with separate read/write ports and clocks
// ------------------------------------------------------------------
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
    // RAM memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end
endmodule