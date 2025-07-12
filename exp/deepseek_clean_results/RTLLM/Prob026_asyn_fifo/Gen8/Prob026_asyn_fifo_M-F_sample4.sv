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
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1 = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync2 = 0;

    // Binary pointer increment
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
        end
    end

    // Binary to Gray conversion
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_gray <= 0;
        end else begin
            wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
        end
    end

    // Read pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_gray_sync2, rptr_gray_sync1} <= 0;
        end else begin
            {rptr_gray_sync2, rptr_gray_sync1} <= {rptr_gray_sync1, rptr_gray};
        end
    end

    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync1 = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync2 = 0;

    // Binary pointer increment
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
        end
    end

    // Binary to Gray conversion
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_gray <= 0;
        end else begin
            rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
        end
    end

    // Write pointer synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_gray_sync2, wptr_gray_sync1} <= 0;
        end else begin
            {wptr_gray_sync2, wptr_gray_sync1} <= {wptr_gray_sync1, wptr_gray};
        end
    end

    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_gray_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync2);

endmodule

module dual_port_RAM #(
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

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule