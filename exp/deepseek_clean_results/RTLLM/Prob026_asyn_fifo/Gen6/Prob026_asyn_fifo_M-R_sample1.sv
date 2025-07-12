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
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be a power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Instantiate dual-port RAM
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

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + wen;
    wire [PTR_WIDTH-1:0] wgray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + ren;
    wire [PTR_WIDTH-1:0] rgray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;

    // RAM address assignment
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Pointer synchronization
    reg [PTR_WIDTH-1:0] rptr_sync_wclk [0:2];
    reg [PTR_WIDTH-1:0] wptr_sync_rclk [0:2];

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {wptr_bin, wptr_gray} <= 0;
        else {wptr_bin, wptr_gray} <= {wptr_bin_next, wgray_next};
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {rptr_bin, rptr_gray} <= 0;
        else {rptr_bin, rptr_gray} <= {rptr_bin_next, rgray_next};
    end

    // Synchronizers using generate
    genvar i;
    generate
        // Write pointer sync to read domain
        always @(posedge rclk or negedge rrstn) begin
            if (!rrstn) begin
                wptr_sync_rclk[0] <= 0;
                wptr_sync_rclk[1] <= 0;
                wptr_sync_rclk[2] <= 0;
            end else begin
                wptr_sync_rclk[0] <= wptr_gray;
                for (i = 1; i < 3; i = i+1)
                    wptr_sync_rclk[i] <= wptr_sync_rclk[i-1];
            end
        end

        // Read pointer sync to write domain
        always @(posedge wclk or negedge wrstn) begin
            if (!wrstn) begin
                rptr_sync_wclk[0] <= 0;
                rptr_sync_wclk[1] <= 0;
                rptr_sync_wclk[2] <= 0;
            end else begin
                rptr_sync_wclk[0] <= rptr_gray;
                for (i = 1; i < 3; i = i+1)
                    rptr_sync_wclk[i] <= rptr_sync_wclk[i-1];
            end
        end
    endgenerate

    // Full/empty detection
    assign wfull = (wgray_next == {~rptr_sync_wclk[2][PTR_WIDTH-1:PTR_WIDTH-2], 
                                  rptr_sync_wclk[2][PTR_WIDTH-3:0]});
    assign rempty = (rgray_next == wptr_sync_rclk[2]);

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