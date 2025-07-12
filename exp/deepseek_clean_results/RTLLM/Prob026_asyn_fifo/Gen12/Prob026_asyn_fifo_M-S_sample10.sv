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
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];

    // Dual-port RAM instance
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
    reg [PTR_WIDTH-1:0] wptr;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    
    // Read pointer synchronization (2-stage)
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    wire [PTR_WIDTH-1:0] rptr_sync_gray = rptr_sync2;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            {rptr_sync2, rptr_sync1} <= 0;
        end else begin
            if (wen) wptr <= wptr + 1;
            {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
        end
    end

    // Read domain
    reg [PTR_WIDTH-1:0] rptr;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    
    // Write pointer synchronization (2-stage)
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    wire [PTR_WIDTH-1:0] wptr_sync_gray = wptr_sync2;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            {wptr_sync2, wptr_sync1} <= 0;
        end else begin
            if (ren) rptr <= rptr + 1;
            {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
        end
    end

    // Full/empty detection
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 1'b0;
        else wfull <= (wptr_gray == {~rptr_sync_gray[PTR_WIDTH-1:PTR_WIDTH-2], 
                                     rptr_sync_gray[PTR_WIDTH-3:0]});
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1'b1;
        else rempty <= (rptr_gray == wptr_sync_gray);
    end

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

    always @(posedge wclk) begin
        if (wenc) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule