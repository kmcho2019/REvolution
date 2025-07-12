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

    // Validate DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $error("FIFO depth must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // Write domain signals
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] waddr_next = waddr_bin + (winc && !wfull);
    wire [PTR_WIDTH-1:0] wptr_gray_next = (waddr_next >> 1) ^ waddr_next;

    // Read domain signals
    reg [PTR_WIDTH-1:0] raddr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;
    wire [PTR_WIDTH-1:0] raddr_next = raddr_bin + (rinc && !rempty);
    wire [PTR_WIDTH-1:0] rptr_gray_next = (raddr_next >> 1) ^ raddr_next;

    // Synchronization chains
    reg [PTR_WIDTH-1:0] rptr_sync0, rptr_sync1;  // Read to write sync
    reg [PTR_WIDTH-1:0] wptr_sync0, wptr_sync1;  // Write to read sync

    // Write pointer updates
    assign waddr_bin = !wrstn ? 0 : waddr_next;
    assign wptr_gray = !wrstn ? 0 : wptr_gray_next;

    // Read pointer updates
    assign raddr_bin = !rrstn ? 0 : raddr_next;
    assign rptr_gray = !rrstn ? 0 : rptr_gray_next;

    // Read to write domain synchronization
    assign rptr_sync0 = !wrstn ? 0 : rptr_gray;
    assign rptr_sync1 = !wrstn ? 0 : rptr_sync0;

    // Write to read domain synchronization
    assign wptr_sync0 = !rrstn ? 0 : wptr_gray;
    assign wptr_sync1 = !rrstn ? 0 : wptr_sync0;

    // Full condition: Gray code comparison
    assign wfull = (wptr_gray == {~rptr_sync1[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync1[PTR_WIDTH-3:0]});

    // Empty condition: pointers equal
    assign rempty = (rptr_gray == wptr_sync1);

    // Clocked elements (only the RAM is clocked in this refactored version)
    always @(posedge wclk) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            waddr_bin <= waddr_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    always @(posedge rclk) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            raddr_bin <= raddr_next;
            rptr_gray <= rptr_gray_next;
        end
    end

endmodule

// Dual-port RAM module (unchanged)
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