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

    // Calculate address and pointer widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // Extra bit for full/empty detection

    // ========== Write Domain Signals ==========
    reg [PTR_WIDTH-1:0] wptr_bin;          // Binary write pointer
    wire [PTR_WIDTH-1:0] wptr_gray;        // Gray code write pointer
    reg [PTR_WIDTH-1:0] rptr_gray_sync1;   // Synchronized read pointer (stage 1)
    reg [PTR_WIDTH-1:0] rptr_gray_sync2;   // Synchronized read pointer (stage 2)

    // ========== Read Domain Signals ==========
    reg [PTR_WIDTH-1:0] rptr_bin;          // Binary read pointer
    wire [PTR_WIDTH-1:0] rptr_gray;        // Gray code read pointer
    reg [PTR_WIDTH-1:0] wptr_gray_sync1;   // Synchronized write pointer (stage 1)
    reg [PTR_WIDTH-1:0] wptr_gray_sync2;   // Synchronized write pointer (stage 2)

    // Gray code conversion
    assign wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    assign rptr_gray = rptr_bin ^ (rptr_bin >> 1);

    // RAM interface signals
    wire wen = winc && !wfull;  // Write enable when not full
    wire ren = rinc && !rempty; // Read enable when not empty
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

    // ========== Write Domain Logic ==========
    // Synchronize read pointer to write clock domain
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

    // Full detection: When MSBs are different but other bits match
    assign wfull = (wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                   rptr_gray_sync2[PTR_WIDTH-3:0]});

    // ========== Read Domain Logic ==========
    // Synchronize write pointer to read clock domain
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

    // Empty detection: When pointers are equal
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