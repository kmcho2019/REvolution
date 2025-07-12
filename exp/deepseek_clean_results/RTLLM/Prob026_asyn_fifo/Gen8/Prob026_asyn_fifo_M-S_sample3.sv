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
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Instantiate RAM module
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
    reg [PTR_WIDTH-1:0] wptr = 0;
    reg [PTR_WIDTH-1:0] rptr_sync1 = 0, rptr_sync2 = 0;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (wen) begin
            wptr <= wptr + 1;
        end
    end
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    assign waddr = wptr[ADDR_WIDTH-1:0];

    // Read pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync2, rptr_sync1} <= 0;
        end else begin
            {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
        end
    end

    // Read domain
    reg [PTR_WIDTH-1:0] rptr = 0;
    reg [PTR_WIDTH-1:0] wptr_sync1 = 0, wptr_sync2 = 0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else if (ren) begin
            rptr <= rptr + 1;
        end
    end
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    assign raddr = rptr[ADDR_WIDTH-1:0];

    // Write pointer synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync2, wptr_sync1} <= 0;
        end else begin
            {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
        end
    end

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                    rptr_sync2[PTR_WIDTH-3:0]});
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
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule