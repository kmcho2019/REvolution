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

    // RAM signals
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // RAM instantiation
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
    reg [PTR_WIDTH-1:0] wptr, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_next = wptr + (winc && !wfull);
    wire [PTR_WIDTH-1:0] wptr_gray_next = (wptr_next >> 1) ^ wptr_next;
    assign waddr = wptr[ADDR_WIDTH-1:0];

    // Read domain
    reg [PTR_WIDTH-1:0] rptr, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_next = rptr + (rinc && !rempty);
    wire [PTR_WIDTH-1:0] rptr_gray_next = (rptr_next >> 1) ^ rptr_next;
    assign raddr = rptr[ADDR_WIDTH-1:0];

    // Pointer synchronization
    reg [PTR_WIDTH-1:0] rptr_gray_sync0, rptr_gray_sync1;
    reg [PTR_WIDTH-1:0] wptr_gray_sync0, wptr_gray_sync1;

    // Write clock domain logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
            rptr_gray_sync0 <= 0;
            rptr_gray_sync1 <= 0;
        end else begin
            wptr <= wptr_next;
            wptr_gray <= wptr_gray_next;
            rptr_gray_sync0 <= rptr_gray;
            rptr_gray_sync1 <= rptr_gray_sync0;
        end
    end

    // Read clock domain logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
            wptr_gray_sync0 <= 0;
            wptr_gray_sync1 <= 0;
            rempty <= 1'b1;
        end else begin
            rptr <= rptr_next;
            rptr_gray <= rptr_gray_next;
            wptr_gray_sync0 <= wptr_gray;
            wptr_gray_sync1 <= wptr_gray_sync0;
        end
    end

    // Full condition
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= ((wptr_gray_next == {~rptr_gray_sync1[PTR_WIDTH-1:PTR_WIDTH-2],
                                         rptr_gray_sync1[PTR_WIDTH-3:0]}) ||
                      (wptr_gray_next == rptr_gray_sync1));
        end
    end

    // Empty condition
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rptr_gray_next == wptr_gray_sync1);
        end
    end

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

    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (ren) rdata <= mem[raddr];
    end

endmodule