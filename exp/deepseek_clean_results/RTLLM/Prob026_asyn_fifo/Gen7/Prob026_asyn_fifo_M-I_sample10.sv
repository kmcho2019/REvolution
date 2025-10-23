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

    // Parameter validation
    initial begin
        if (DEPTH < 2 || (DEPTH & (DEPTH-1)) != 0) begin
            $error("DEPTH must be power of 2 and >= 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr_gray[PTR_WIDTH-2:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_gray[PTR_WIDTH-2:0];

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
    reg [PTR_WIDTH-1:0] rptr_sync1 = 0, rptr_sync2 = 0;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
        end
    end

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_sync1 = 0, wptr_sync2 = 0;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
        end
    end

    // Synchronizers
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync2, rptr_sync1} <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync2, wptr_sync1} <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Full/empty detection
    wire full_cond = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_sync2[PTR_WIDTH-3:0]});
    wire empty_cond = (rptr_gray == wptr_sync2);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 1'b0;
        else wfull <= full_cond;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1'b1;
        else rempty <= empty_cond;
    end

endmodule

module dual_port_RAM #(
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
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
    
    always @(posedge wclk) begin
        if (wenc) RAM_MEM[waddr] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (renc) rdata <= RAM_MEM[raddr];
    end
endmodule