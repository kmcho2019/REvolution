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

    // Validate DEPTH is power of 2
    initial if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Write domain signals
    reg [ADDR_WIDTH:0] wptr_bin;
    wire [ADDR_WIDTH:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [ADDR_WIDTH:0] wptr_bin_next = wptr_bin + (winc && !wfull);
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];

    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin;
    wire [ADDR_WIDTH:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    wire [ADDR_WIDTH:0] rptr_bin_next = rptr_bin + (rinc && !rempty);
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Synchronizers
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;

    // RAM instance
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .waddr(waddr),
        .wdata(wdata),
        .wenc(winc && !wfull),
        .rclk(rclk),
        .raddr(raddr),
        .renc(rinc && !rempty),
        .rdata(rdata)
    );

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            if (winc && !wfull) wptr_bin <= wptr_bin_next;
            wptr_sync1 <= rptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            if (rinc && !rempty) rptr_bin <= rptr_bin_next;
            rptr_sync1 <= wptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Full/empty detection
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 1'b0;
        else wfull <= (wptr_gray == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                    rptr_sync2[ADDR_WIDTH-2:0]});
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1'b1;
        else rempty <= (rptr_gray == wptr_sync2);
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

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];

endmodule