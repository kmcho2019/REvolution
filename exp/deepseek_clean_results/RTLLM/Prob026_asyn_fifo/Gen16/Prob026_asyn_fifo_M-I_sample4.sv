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
        if ((DEPTH & (DEPTH-1)) != 0) begin
            $error("Error: DEPTH must be power of 2 (given %0d)", DEPTH);
            $finish;
        end
        if (WIDTH < 1) begin
            $error("Error: WIDTH must be positive (given %0d)", WIDTH);
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Clock-gated write enable for power savings
    wire wclk_gated = wclk & wen;

    // Dual-port RAM instance with clock gating
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk_gated),
        .wenc(1'b1),  // Always enabled when clock is active
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain logic
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2, rptr_sync3;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
            rptr_sync3 <= 0;
            wfull <= 0;
        end else begin
            // Update write pointer
            if (wen) begin
                wptr_bin <= wptr_bin + 1;
                wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
            end
            
            // Three-stage synchronizer for read pointer
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
            rptr_sync3 <= rptr_sync2;
            
            // Optimized full detection
            wfull <= (wptr_gray == {~rptr_sync3[PTR_WIDTH-1:PTR_WIDTH-2], 
                     rptr_sync3[PTR_WIDTH-3:0]});
        end
    end

    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    // Read domain logic
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2, wptr_sync3;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
            wptr_sync3 <= 0;
            rempty <= 1;
        end else begin
            // Update read pointer
            if (ren) begin
                rptr_bin <= rptr_bin + 1;
                rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
            end
            
            // Three-stage synchronizer for write pointer
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
            wptr_sync3 <= wptr_sync2;
            
            // Optimized empty detection
            rempty <= (rptr_gray == wptr_sync3);
        end
    end

    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Protection against same address access
    always @(*) begin
        if (wen && ren && (waddr == raddr)) begin
            $warning("Warning: Simultaneous read/write to same address %0h", waddr);
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
        if (wenc) mem[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) rdata <= mem[raddr];
    end

endmodule