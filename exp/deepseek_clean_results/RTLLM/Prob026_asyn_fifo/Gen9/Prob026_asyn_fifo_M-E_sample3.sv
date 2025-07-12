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
    dp_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wen(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .ren(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain
    reg [PTR_WIDTH-1:0] wptr = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_mirror = 0;
    reg [PTR_WIDTH-1:0] rptr_sync[0:3];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr <= wptr + 1;
            wptr_gray <= (wptr + 1) ^ ((wptr + 1) >> 1);
        end
    end
    assign waddr = wptr[ADDR_WIDTH-1:0];

    // Read pointer synchronization chain (4 stages)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (int i=0; i<4; i++) rptr_sync[i] <= 0;
        end else begin
            rptr_sync[0] <= rptr_mirror;
            for (int i=1; i<4; i++) rptr_sync[i] <= rptr_sync[i-1];
        end
    end

    // Read domain
    reg [PTR_WIDTH-1:0] rptr = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_mirror = 0;
    reg [PTR_WIDTH-1:0] wptr_sync[0:3];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr <= rptr + 1;
            rptr_gray <= (rptr + 1) ^ ((rptr + 1) >> 1);
        end
    end
    assign raddr = rptr[ADDR_WIDTH-1:0];

    // Write pointer synchronization chain (4 stages)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (int i=0; i<4; i++) wptr_sync[i] <= 0;
        end else begin
            wptr_sync[0] <= wptr_mirror;
            for (int i=1; i<4; i++) wptr_sync[i] <= wptr_sync[i-1];
        end
    end

    // Mirror pointer updates
    always @(posedge wclk) wptr_mirror <= wptr_gray;
    always @(posedge rclk) rptr_mirror <= rptr_gray;

    // Early full/empty prediction
    wire [PTR_WIDTH-1:0] wptr_next_gray = (wptr + 1) ^ ((wptr + 1) >> 1);
    wire [PTR_WIDTH-1:0] rptr_next_gray = (rptr + 1) ^ ((rptr + 1) >> 1);

    assign wfull = (wptr_next_gray == {~rptr_sync[3][PTR_WIDTH-1:PTR_WIDTH-2],
                                      rptr_sync[3][PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync[3]);

endmodule

module dp_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wen,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input ren,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    always @(posedge rclk) if (ren) rdata <= mem[raddr];

endmodule