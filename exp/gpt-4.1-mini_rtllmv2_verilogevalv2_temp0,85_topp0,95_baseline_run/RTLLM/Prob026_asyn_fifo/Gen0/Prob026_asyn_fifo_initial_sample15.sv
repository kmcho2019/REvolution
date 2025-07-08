module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input                wclk,
    input                rclk,
    input                wrstn,
    input                rrstn,
    input                winc,
    input                rinc,
    input      [WIDTH-1:0] wdata,
    output               wfull,
    output               rempty,
    output     [WIDTH-1:0] rdata
);

    // Dual-port RAM module declaration
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
        .rdata(rdata)
    );

    // Pointer widths: Use one extra bit for full/empty logic (DEPTH must be power of 2)
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Binary pointers
    reg [PTR_WIDTH-1:0] waddr_bin, raddr_bin;

    // Gray-coded pointers
    reg [PTR_WIDTH-1:0] wptr, rptr;

    // Pointer synchronizers
    reg [PTR_WIDTH-1:0] rptr_wclk1, rptr_wclk2; // rptr synchronized into wclk domain
    reg [PTR_WIDTH-1:0] wptr_rclk1, wptr_rclk2; // wptr synchronized into rclk domain

    // Write enable and read enable signals for RAM
    wire wen, ren;

    // RAM addresses (lower ADDR_WIDTH bits of binary pointers)
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];

    // -------------------
    // Binary to Gray code function
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Gray code to binary function (used in synchronization: convert back for comparisons)
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for(i=PTR_WIDTH-2; i>=0; i=i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction

    // -------------------
    // Write pointer logic (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else if (winc && !wfull) begin
            waddr_bin <= waddr_bin + 1'b1;
            wptr <= bin2gray(waddr_bin + 1'b1);
        end else begin
            waddr_bin <= waddr_bin;
            wptr <= wptr;
        end
    end

    // Read pointer logic (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else if (rinc && !rempty) begin
            raddr_bin <= raddr_bin + 1'b1;
            rptr <= bin2gray(raddr_bin + 1'b1);
        end else begin
            raddr_bin <= raddr_bin;
            rptr <= rptr;
        end
    end

    // -------------------
    // Synchronize read pointer into write clock domain (2-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_wclk1 <= 0;
            rptr_wclk2 <= 0;
        end else begin
            rptr_wclk1 <= rptr;
            rptr_wclk2 <= rptr_wclk1;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_rclk1 <= 0;
            wptr_rclk2 <= 0;
        end else begin
            wptr_rclk1 <= wptr;
            wptr_rclk2 <= wptr_rclk1;
        end
    end

    // -------------------
    // Full and Empty logic by comparing Gray codes
    // Full condition:
    // when write pointer is one cycle ahead of read pointer with MSB and next MSB inverted and rest same
    // full = (wptr == {~rptr_wclk2[PTR_WIDTH-1:PTR_WIDTH-2], rptr_wclk2[PTR_WIDTH-3:0]})
    assign wfull = (wptr == {~rptr_wclk2[PTR_WIDTH-1], ~rptr_wclk2[PTR_WIDTH-2], rptr_wclk2[PTR_WIDTH-3:0]});

    // Empty condition:
    // when read pointer equals synchronized write pointer in read clock domain
    assign rempty = (rptr == wptr_rclk2);

    // -------------------
    // RAM write enable: write when write increment and not full
    assign wen = winc && !wfull;

    // RAM read enable: read when read increment and not empty
    assign ren = rinc && !rempty;

endmodule

// ----------------------------------------
// Dual-port RAM module definition
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input                     wclk,
    input                     wenc,
    input      [ADDR_WIDTH-1:0] waddr,
    input      [WIDTH-1:0]     wdata,
    input                     rclk,
    input                     renc,
    input      [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
);

    // Memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
    end

endmodule