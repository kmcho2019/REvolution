module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Dual-port RAM
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

    // Write domain
    reg [ADDR_WIDTH:0] wptr_gray = 0;
    reg [ADDR_WIDTH:0] rptr_sync1 = 0, rptr_sync2 = 0;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_gray <= wptr_gray ^ ((wptr_gray >> 1) ^ wptr_gray) + 1;
        end
    end

    // Read domain
    reg [ADDR_WIDTH:0] rptr_gray = 0;
    reg [ADDR_WIDTH:0] wptr_sync1 = 0, wptr_sync2 = 0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_gray <= rptr_gray ^ ((rptr_gray >> 1) ^ rptr_gray) + 1;
        end
    end

    // Synchronizers
    always @(posedge wclk) begin
        {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
    end

    always @(posedge rclk) begin
        {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
    end

    // Address generation
    assign waddr = wptr_gray[ADDR_WIDTH:1] ^ wptr_gray[ADDR_WIDTH-1:0];
    assign raddr = rptr_gray[ADDR_WIDTH:1] ^ rptr_gray[ADDR_WIDTH-1:0];

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                 rptr_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync2);

endmodule

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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule