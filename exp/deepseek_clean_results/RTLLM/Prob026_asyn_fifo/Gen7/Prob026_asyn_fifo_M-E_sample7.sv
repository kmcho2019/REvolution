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
    localparam SAFE_ZONE = 2;  // Prevent metastability near boundaries

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Instantiate RAM module
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
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
    reg [PTR_WIDTH-1:0] wptr = 0;
    reg [PTR_WIDTH-1:0] rptr_mirror = 0;
    reg [PTR_WIDTH-1:0] rptr_sync1 = 0, rptr_sync2 = 0;

    // Combined binary-Gray counter
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (wen) begin
            wptr <= wptr + 1;
        end
    end
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    assign waddr = wptr[ADDR_WIDTH-1:0];

    // Read pointer synchronization with mirror update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync2, rptr_sync1} <= 0;
            rptr_mirror <= 0;
        end else begin
            {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray_synced};
            // Update mirror only when stable
            if (rptr_sync2 == rptr_sync1) begin
                rptr_mirror <= rptr_sync2;
            end
        end
    end

    // Read domain (symmetric to write domain)
    reg [PTR_WIDTH-1:0] rptr = 0;
    reg [PTR_WIDTH-1:0] wptr_mirror = 0;
    reg [PTR_WIDTH-1:0] wptr_sync1 = 0, wptr_sync2 = 0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else if (ren) begin
            rptr <= rptr + 1;
        end
    end
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    assign raddr = rptr[ADDR_WIDTH-1:0];

    // Write pointer synchronization with mirror update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync2, wptr_sync1} <= 0;
            wptr_mirror <= 0;
        end else begin
            {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray_synced};
            if (wptr_sync2 == wptr_sync1) begin
                wptr_mirror <= wptr_sync2;
            end
        end
    end

    // Full/empty detection using pointer difference
    wire [PTR_WIDTH:0] wdiff = {1'b0, wptr} - {1'b0, rptr_mirror};
    wire [PTR_WIDTH:0] rdiff = {1'b0, wptr_mirror} - {1'b0, rptr};

    assign wfull = (wdiff >= DEPTH - SAFE_ZONE);
    assign rempty = (rdiff <= SAFE_ZONE);

    // Cross-clock gray code signals
    wire [PTR_WIDTH-1:0] rptr_gray_synced;
    wire [PTR_WIDTH-1:0] wptr_gray_synced;
    
    assign rptr_gray_synced = rptr_gray;
    assign wptr_gray_synced = wptr_gray;

endmodule