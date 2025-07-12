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

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr, wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_next ^ (wptr_next >> 1);

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr, rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_next ^ (rptr_next >> 1);

    // Synchronization registers
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;

    // Control signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // RAM instance
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

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_next;
            wptr <= wptr_gray_next;
        end
    end

    // Read pointer synchronization (to write domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync2, rptr_sync1} <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_next;
            rptr <= rptr_gray_next;
        end
    end

    // Write pointer synchronization (to read domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync2, wptr_sync1} <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                  rptr_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync2);

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