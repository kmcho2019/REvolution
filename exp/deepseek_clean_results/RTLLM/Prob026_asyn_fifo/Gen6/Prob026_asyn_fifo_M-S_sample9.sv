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
    reg [ADDR_WIDTH:0] wptr = 0;
    reg [ADDR_WIDTH:0] rptr_sync = 0;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (wen) begin
            wptr <= wptr ^ {1'b0, wptr[ADDR_WIDTH:1] ^ wptr[ADDR_WIDTH-1:0]};
        end
    end

    // Read domain
    reg [ADDR_WIDTH:0] rptr = 0;
    reg [ADDR_WIDTH:0] wptr_sync = 0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else if (ren) begin
            rptr <= rptr ^ {1'b0, rptr[ADDR_WIDTH:1] ^ rptr[ADDR_WIDTH-1:0]};
        end
    end

    // Synchronizers
    always @(posedge wclk) rptr_sync <= rptr;
    always @(posedge rclk) wptr_sync <= wptr;

    // Address calculation (Gray to binary)
    assign waddr = wptr[ADDR_WIDTH:1] ^ wptr[ADDR_WIDTH-1:0];
    assign raddr = rptr[ADDR_WIDTH:1] ^ rptr[ADDR_WIDTH-1:0];

    // Full/empty detection
    assign wfull = (wptr == {~rptr_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                            rptr_sync[ADDR_WIDTH-2:0]});
    assign rempty = (rptr == wptr_sync);

endmodule