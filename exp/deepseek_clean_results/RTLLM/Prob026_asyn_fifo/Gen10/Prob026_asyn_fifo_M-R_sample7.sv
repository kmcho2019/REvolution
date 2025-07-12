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

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + wen;
    wire [PTR_WIDTH-1:0] wptr_next_gray = wptr_next ^ (wptr_next >> 1);

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + ren;
    wire [PTR_WIDTH-1:0] rptr_next_gray = rptr_next ^ (rptr_next >> 1);

    // Pointer updates
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else begin
            wptr_bin <= wptr_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else begin
            rptr_bin <= rptr_next;
        end
    end

    // Address assignments
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Synchronizers
    reg [PTR_WIDTH-1:0] rptr_sync[0:1];
    reg [PTR_WIDTH-1:0] wptr_sync[0:1];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
        end
    end

    // Full/empty detection
    assign wfull = (wptr_next_gray == {~rptr_sync[1][PTR_WIDTH-1:PTR_WIDTH-2],
                                     rptr_sync[1][PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync[1]);

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