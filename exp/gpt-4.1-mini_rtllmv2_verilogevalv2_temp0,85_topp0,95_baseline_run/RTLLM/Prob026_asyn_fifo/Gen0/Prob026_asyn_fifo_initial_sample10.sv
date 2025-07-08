module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,
    input  wire                 rrstn,
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output wire                 wfull,
    output wire                 rempty,
    output wire [WIDTH-1:0]     rdata
);

    // Calculate pointer width as clog2(DEPTH), must be at least 1
    localparam PTR_WIDTH = $clog2(DEPTH);

    // Binary and Gray pointers for write and read
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;

    reg [PTR_WIDTH-1:0] wptr; // Gray coded write pointer
    reg [PTR_WIDTH-1:0] rptr; // Gray coded read pointer

    // Synchronized pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2; // rptr synchronized into write clock domain
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2; // wptr synchronized into read clock domain

    // Binary versions of synchronized pointers in respective domains
    wire [PTR_WIDTH-1:0] raddr_bin_sync; // synchronized rptr in write clk domain, binary
    wire [PTR_WIDTH-1:0] waddr_bin_sync; // synchronized wptr in read clk domain, binary

    // Write enable and read enable signals for RAM
    wire wen;
    wire ren;

    // RAM write and read addresses - from binary pointers
    wire [PTR_WIDTH-1:0] waddr;
    wire [PTR_WIDTH-1:0] raddr;

    // Output data from dual-port RAM
    wire [WIDTH-1:0] ram_rdata;

    // Functions for binary <-> Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin = 0;
            for (i = PTR_WIDTH-1; i >= 0; i = i - 1) begin
                if (i == PTR_WIDTH-1)
                    bin[i] = gray[i];
                else
                    bin[i] = bin[i+1] ^ gray[i];
            end
            gray2bin = bin;
        end
    endfunction

    // Write pointer binary counter
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
        end else begin
            if (winc && !wfull)
                waddr_bin <= waddr_bin + 1'b1;
        end
    end

    // Read pointer binary counter
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
        end else begin
            if (rinc && !rempty)
                raddr_bin <= raddr_bin + 1'b1;
        end
    end

    // Convert binary pointers to Gray code
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr <= 0;
        else
            wptr <= bin2gray(waddr_bin);
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr <= 0;
        else
            rptr <= bin2gray(raddr_bin);
    end

    // Synchronize read pointer into write clock domain (two-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Synchronize write pointer into read clock domain (two-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Convert synchronized Gray pointers back to binary for comparison and RAM addressing
    assign raddr_bin_sync = gray2bin(rptr_sync2);
    assign waddr_bin_sync = gray2bin(wptr_sync2);

    // RAM addresses are lower PTR_WIDTH bits of binary pointers
    assign waddr = waddr_bin;
    assign raddr = raddr_bin;

    // Write enable: active when winc asserted and FIFO not full
    assign wen = winc & ~wfull;
    // Read enable: active when rinc asserted and FIFO not empty
    assign ren = rinc & ~rempty;

    // Instantiate dual-port RAM module
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

    assign rdata = ram_rdata;

    // Full condition:
    // FIFO is full when write pointer is one position ahead of read pointer with MSB wrap around:
    // wptr = {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], rptr_sync2[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] full_check;
    generate
        if (PTR_WIDTH >= 2) begin
            assign full_check = {~rptr_sync2[PTR_WIDTH-1], ~rptr_sync2[PTR_WIDTH-2], rptr_sync2[PTR_WIDTH-3:0]};
        end else if (PTR_WIDTH == 1) begin
            // For 1-bit pointer, full condition is simply bit inversion
            assign full_check = ~rptr_sync2;
        end else begin
            assign full_check = {PTR_WIDTH{1'b0}}; // Default for PTR_WIDTH=0 no FIFO depth
        end
    endgenerate

    assign wfull = (wptr == full_check);

    // Empty condition:
    // FIFO is empty when read pointer equals synchronized write pointer in read clock domain
    assign rempty = (rptr == wptr_sync2);

endmodule


// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                 wclk,
    input  wire                 wenc,
    input  wire [$clog2(DEPTH)-1:0] waddr,
    input  wire [WIDTH-1:0]     wdata,
    input  wire                 rclk,
    input  wire                 renc,
    input  wire [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]     rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port - synchronous write on wclk when wenc is high
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read port - synchronous read on rclk when renc is high
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // Hold last data if no read enable
    end

endmodule