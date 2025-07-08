module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk, rclk,
    input wrstn, rrstn,
    input winc, rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Dual-port RAM instantiation
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [ADDR_WIDTH:0] waddr_bin = 0;
    reg [ADDR_WIDTH:0] wptr = 0;
    wire [ADDR_WIDTH:0] wgraynext, wbinnext;
    wire wen = winc && !wfull;

    // Read domain signals
    reg [ADDR_WIDTH:0] raddr_bin = 0;
    reg [ADDR_WIDTH:0] rptr = 0;
    wire [ADDR_WIDTH:0] rgraynext, rbinnext;
    wire ren = rinc && !rempty;

    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_syn[1:0];
    reg [ADDR_WIDTH:0] wptr_syn[1:0];

    // RAM address connections
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else begin
            waddr_bin <= wbinnext;
            wptr <= wgraynext;
        end
    end

    assign wbinnext = waddr_bin + (wen ? 1 : 0);
    assign wgraynext = (wbinnext >> 1) ^ wbinnext;

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            raddr_bin <= rbinnext;
            rptr <= rgraynext;
        end
    end

    assign rbinnext = raddr_bin + (ren ? 1 : 0);
    assign rgraynext = (rbinnext >> 1) ^ rbinnext;

    // Synchronize read pointer to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_syn[0] <= 0;
            rptr_syn[1] <= 0;
        end else begin
            rptr_syn[0] <= rptr;
            rptr_syn[1] <= rptr_syn[0];
        end
    end

    // Synchronize write pointer to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_syn[0] <= 0;
            wptr_syn[1] <= 0;
        end else begin
            wptr_syn[0] <= wptr;
            wptr_syn[1] <= wptr_syn[0];
        end
    end

    // Full and empty generation
    assign wfull = (wgraynext == {~rptr_syn[1][ADDR_WIDTH:ADDR_WIDTH-1], 
                                rptr_syn[1][ADDR_WIDTH-2:0]});
    assign rempty = (rgraynext == wptr_syn[1]);

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule