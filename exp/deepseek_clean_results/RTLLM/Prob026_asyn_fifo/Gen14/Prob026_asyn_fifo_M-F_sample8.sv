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

    // Check if DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // ===========================================
    // Write Domain Logic
    // ===========================================
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;
    reg [PTR_WIDTH-1:0] wptr_gray;

    // Binary pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
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

    // ===========================================
    // Read Domain Logic
    // ===========================================
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + 1'b1;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Binary pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
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

    // ===========================================
    // Pointer Synchronization
    // ===========================================
    // Write pointer synchronized to read clock domain
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Read pointer synchronized to write clock domain
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // ===========================================
    // Full/Empty Detection
    // ===========================================
    // Full when Gray(wptr) == {~Gray(rptr_sync)[n:n-1], Gray(rptr_sync)[n-2:0]}
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync2[PTR_WIDTH-3:0]});

    // Empty when Gray(rptr) == Gray(wptr_sync)
    assign rempty = (rptr_gray == wptr_sync2);

    // ===========================================
    // Memory Instance
    // ===========================================
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) mem (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

endmodule

// Dual-port RAM
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
        end
    end

endmodule