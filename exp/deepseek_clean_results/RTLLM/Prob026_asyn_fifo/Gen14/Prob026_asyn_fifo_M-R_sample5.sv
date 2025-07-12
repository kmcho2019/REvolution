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

    // Parameter validation and local calculations
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("Error: DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ================= Write Domain =================
    // Write pointer and Gray code
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc & ~wfull);
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wptr_bin <= 0;
        else        wptr_bin <= wptr_bin_next;
    end

    // Read pointer synchronization (2-stage)
    wire [PTR_WIDTH-1:0] rptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync2, rptr_sync1} <= 0;
        else        {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
    end

    // Full detection
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync2[PTR_WIDTH-3:0]});

    // ================= Read Domain =================
    // Read pointer and Gray code
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc & ~rempty);
    assign rptr_gray = rptr_bin ^ (rptr_bin >> 1);

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rptr_bin <= 0;
        else        rptr_bin <= rptr_bin_next;
    end

    // Write pointer synchronization (2-stage)
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync2, wptr_sync1} <= 0;
        else        {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
    end

    // Empty detection
    assign rempty = (rptr_gray == wptr_sync2);

    // ================= Memory Interface =================
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Dual-port RAM instance
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .waddr(waddr),
        .wdata(wdata),
        .winc(winc & ~wfull),
        .rclk(rclk),
        .raddr(raddr),
        .rinc(rinc & ~rempty),
        .rdata(rdata)
    );

endmodule

// Optimized dual-port RAM
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input winc,
    input rclk,
    input [$clog2(DEPTH)-1:0] raddr,
    input rinc,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (winc) mem[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (rinc) rdata <= mem[raddr];
    end

endmodule