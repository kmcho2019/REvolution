module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 3  // Adaptive synchronization stages
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wire wfull,
    output wire rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // RAM control signals
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

    // Pointer registers (binary)
    reg [PTR_WIDTH-1:0] wptr, rptr;
    
    // Next pointer values
    wire [PTR_WIDTH-1:0] wptr_next = wptr + wen;
    wire [PTR_WIDTH-1:0] rptr_next = rptr + ren;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else begin
            wptr <= wptr_next;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else begin
            rptr <= rptr_next;
        end
    end

    // Pointer difference calculation
    reg [PTR_WIDTH:0] wdiff, rdiff;
    wire [PTR_WIDTH:0] wdiff_next = wptr - rptr_sync;
    wire [PTR_WIDTH:0] rdiff_next = wptr_sync - rptr;

    // Clock domain crossing synchronizers
    reg [PTR_WIDTH-1:0] wptr_sync [0:SYNC_STAGES-1];
    reg [PTR_WIDTH-1:0] rptr_sync [0:SYNC_STAGES-1];
    
    // Write pointer synchronization (to read domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (integer i = 0; i < SYNC_STAGES; i = i + 1)
                wptr_sync[i] <= 0;
        end else begin
            wptr_sync[0] <= wptr;
            for (integer i = 1; i < SYNC_STAGES; i = i + 1)
                wptr_sync[i] <= wptr_sync[i-1];
        end
    end

    // Read pointer synchronization (to write domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (integer i = 0; i < SYNC_STAGES; i = i + 1)
                rptr_sync[i] <= 0;
        end else begin
            rptr_sync[0] <= rptr;
            for (integer i = 1; i < SYNC_STAGES; i = i + 1)
                rptr_sync[i] <= rptr_sync[i-1];
        end
    end

    // Difference registers update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wdiff <= 0;
        end else begin
            wdiff <= wdiff_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rdiff <= 0;
        end else begin
            rdiff <= rdiff_next;
        end
    end

    // Full/empty detection with safe window
    wire [PTR_WIDTH:0] wdiff_safe = wdiff - (SYNC_STAGES >> 1);
    wire [PTR_WIDTH:0] rdiff_safe = rdiff + (SYNC_STAGES >> 1);
    
    assign wfull = (wdiff_safe >= DEPTH);
    assign rempty = (rdiff_safe == 0);

    // RAM address assignment
    assign waddr = wptr[ADDR_WIDTH-1:0];
    assign raddr = rptr[ADDR_WIDTH-1:0];

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