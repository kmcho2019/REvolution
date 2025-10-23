module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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

    // RAM interface signals
    wire wenc;
    wire [ADDR_WIDTH-1:0] waddr;
    wire renc;
    wire [ADDR_WIDTH-1:0] raddr;

    // Instantiate dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain signals
    reg [ADDR_WIDTH:0] wptr_bin = 0;
    reg [ADDR_WIDTH:0] wptr_gray = 0;
    wire [ADDR_WIDTH:0] wptr_gray_next = wptr_bin + 1'b1 ^ ((wptr_bin + 1'b1) >> 1);

    // Read domain signals
    reg [ADDR_WIDTH:0] rptr_bin = 0;
    reg [ADDR_WIDTH:0] rptr_gray = 0;
    wire [ADDR_WIDTH:0] rptr_gray_next = rptr_bin + 1'b1 ^ ((rptr_bin + 1'b1) >> 1);

    // Synchronizer chains
    reg [ADDR_WIDTH:0] sync_rptr_gray[1:0];
    reg [ADDR_WIDTH:0] sync_wptr_gray[1:0];

    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1'b1;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1'b1;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Read pointer synchronization to write domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            sync_rptr_gray[0] <= 0;
            sync_rptr_gray[1] <= 0;
        end else begin
            sync_rptr_gray[0] <= rptr_gray;
            sync_rptr_gray[1] <= sync_rptr_gray[0];
        end
    end

    // Write pointer synchronization to read domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            sync_wptr_gray[0] <= 0;
            sync_wptr_gray[1] <= 0;
        end else begin
            sync_wptr_gray[0] <= wptr_gray;
            sync_wptr_gray[1] <= sync_wptr_gray[0];
        end
    end

    // Address generation
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Control signals
    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;

    // Full/empty detection
    assign wfull = (wptr_gray_next == {~sync_rptr_gray[1][ADDR_WIDTH:ADDR_WIDTH-1], 
                                      sync_rptr_gray[1][ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == sync_wptr_gray[1]);

endmodule

// Dual-port RAM module
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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