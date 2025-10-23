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
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];

    // Dual-port RAM instance
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
    reg [PTR_WIDTH-1:0] wptr, wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2, rptr_sync3;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
            wptr <= wptr_gray;
        end
    end

    // Read pointer synchronization (3-stage for metastability)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_sync3, rptr_sync2, rptr_sync1} <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
            rptr_sync3 <= rptr_sync2;
        end
    end

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr, rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2, wptr_sync3;

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
            rptr <= rptr_gray;
        end
    end

    // Write pointer synchronization (3-stage for metastability)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_sync3, wptr_sync2, wptr_sync1} <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
            wptr_sync3 <= wptr_sync2;
        end
    end

    // Full detection
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= (wptr_gray == {~rptr_sync3[PTR_WIDTH-1:PTR_WIDTH-2], 
                      rptr_sync3[PTR_WIDTH-3:0]});
        end
    end

    // Empty detection
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= (rptr_gray == wptr_sync3);
        end
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
            // Check for read-during-write hazard
            if (wenc && (waddr == raddr)) begin
                rdata <= 'bx; // Unknown if concurrent read/write same address
            end
        end
    end

endmodule