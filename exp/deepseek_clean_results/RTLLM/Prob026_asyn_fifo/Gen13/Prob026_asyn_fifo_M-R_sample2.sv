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
            $display("Error: DEPTH must be power of 2 (given %0d)", DEPTH);
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync2;

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync2;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

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

    // ========== Write Domain ==========
    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
        end
    end

    // Full detection
    wire full_condition = (wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                        rptr_gray_sync2[PTR_WIDTH-3:0]});
    assign wfull = full_condition && (wptr_bin != rptr_gray_sync2);

    // ========== Read Domain ==========
    // Pointer synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
        end else begin
            wptr_gray_sync1 <= wptr_gray;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

    // Empty detection
    assign rempty = (rptr_gray == wptr_gray_sync2);

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