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

    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // Write domain logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            {rptr_gray_sync2, rptr_gray_sync1} <= 0;
        end else begin
            rptr_gray_sync1 <= (rptr_bin ^ (rptr_bin >> 1));
            rptr_gray_sync2 <= rptr_gray_sync1;
            if (wen) wptr_bin <= wptr_bin + 1;
        end
    end

    // Read domain logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            {wptr_gray_sync2, wptr_gray_sync1} <= 0;
        end else begin
            wptr_gray_sync1 <= (wptr_bin ^ (wptr_bin >> 1));
            wptr_gray_sync2 <= wptr_gray_sync1;
            if (ren) rptr_bin <= rptr_bin + 1;
        end
    end

    // Full/empty detection
    assign wfull = ((wptr_bin ^ (wptr_bin >> 1)) == 
                  {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                   rptr_gray_sync2[PTR_WIDTH-3:0]});
    assign rempty = ((rptr_bin ^ (rptr_bin >> 1)) == wptr_gray_sync2);

endmodule

module dual_port_ram #(
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

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];

endmodule