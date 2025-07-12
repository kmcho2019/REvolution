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
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
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
    reg [PTR_WIDTH-1:0] wptr, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
            rptr_sync <= 0;
        end else begin
            if (wen) wptr <= wptr + 1;
            wptr_gray <= wptr ^ (wptr >> 1);
            rptr_sync <= rptr_sync;
        end
    end

    assign waddr = wptr[ADDR_WIDTH-1:0];
    assign wfull = (wptr_gray == {~rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                   rptr_sync[PTR_WIDTH-3:0]});

    // Read domain
    reg [PTR_WIDTH-1:0] rptr, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
            wptr_sync <= 0;
            rempty <= 1;
        end else begin
            if (ren) rptr <= rptr + 1;
            rptr_gray <= rptr ^ (rptr >> 1);
            wptr_sync <= wptr_gray;
            rempty <= (rptr_gray == wptr_sync);
        end
    end

    assign raddr = rptr[ADDR_WIDTH-1:0];

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