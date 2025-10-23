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

    // RAM Interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    assign rdata = ren ? mem[raddr] : {WIDTH{1'b0}};

    // Write Domain Pointers
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (wen ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_bin_next ^ (wptr_bin_next >> 1);
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    // Read Domain Pointers
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (ren ? 1'b1 : 1'b0);
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_bin_next ^ (rptr_bin_next >> 1);
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // Synchronizers
    reg [PTR_WIDTH-1:0] wptr_sync [0:1];
    reg [PTR_WIDTH-1:0] rptr_sync [0:1];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync[0], wptr_sync[1]} <= 0;
        else {wptr_sync[0], wptr_sync[1]} <= {wptr_gray, wptr_sync[0]};
    end

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync[0], rptr_sync[1]} <= 0;
        else {rptr_sync[0], rptr_sync[1]} <= {rptr_gray, rptr_sync[0]};
    end

    // Full/Empty Detection
    wire [PTR_WIDTH-1:0] wptr_for_full = {~rptr_sync[1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                         rptr_sync[1][PTR_WIDTH-3:0]};
    assign wfull = (wptr_gray == wptr_for_full);
    assign rempty = (rptr_gray == wptr_sync[1]);

endmodule