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
        if ((DEPTH & (DEPTH - 1)) != 0)
            $error("DEPTH must be power of 2");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // Extra bit for full/empty detection

    // ================= Write Domain =================
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc & ~wfull);
    wire [PTR_WIDTH-1:0] wptr_gray = (wptr_bin_next >> 1) ^ wptr_bin_next;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wfull <= 0;
        end
        else begin
            wptr_bin <= wptr_bin_next;
            // Full when Gray codes are exactly opposite except MSB
            wfull <= (wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_gray_sync[PTR_WIDTH-3:0]});
        end
    end

    // Read pointer synchronization (2-stage)
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_gray_sync, rptr_gray_sync1} <= 0;
        else        {rptr_gray_sync, rptr_gray_sync1} <= {rptr_gray_sync1, rptr_gray};
    end

    // ================= Read Domain =================
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc & ~rempty);
    wire [PTR_WIDTH-1:0] rptr_gray = (rptr_bin_next >> 1) ^ rptr_bin_next;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rempty <= 1'b1;
        end
        else begin
            rptr_bin <= rptr_bin_next;
            // Empty when pointers match exactly
            rempty <= (rptr_gray == wptr_gray_sync);
        end
    end

    // Write pointer synchronization (2-stage)
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_gray_sync, wptr_gray_sync1} <= 0;
        else        {wptr_gray_sync, wptr_gray_sync1} <= {wptr_gray_sync1, wptr_gray};
    end

    // ================= Memory Interface =================
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire wram_en = winc & ~wfull;
    wire rram_en = rinc & ~rempty;

    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .waddr(waddr),
        .wdata(wdata),
        .wen(wram_en),
        .rclk(rclk),
        .raddr(raddr),
        .ren(rram_en),
        .rdata(rdata)
    );

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input wen,
    input rclk,
    input [$clog2(DEPTH)-1:0] raddr,
    input ren,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wen) begin
            mem[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (ren) begin
            rdata <= mem[raddr];
        end
    end

    // Initialize memory to zero (simulation only)
    initial begin
        for (int i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
    end

endmodule