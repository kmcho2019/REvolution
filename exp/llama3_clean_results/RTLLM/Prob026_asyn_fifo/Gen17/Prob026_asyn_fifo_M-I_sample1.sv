module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

// Dual-port RAM module
reg [WIDTH-1:0] ram [DEPTH-1:0];

// Write pointer
reg [$clog2(DEPTH)-1:0] wptr_bin;
reg [2:0] wptr_gray;
reg [2:0] wptr_sync;

// Read pointer
reg [$clog2(DEPTH)-1:0] rptr_bin;
reg [2:0] rptr_gray;
reg [2:0] rptr_sync;

// Gray code conversion logic
always @(*) begin
    wptr_gray[0] = wptr_bin[0] ^ wptr_bin[1];
    wptr_gray[1] = wptr_bin[1] ^ wptr_bin[2];
    wptr_gray[2] = wptr_bin[2];
end

always @(*) begin
    rptr_gray[0] = rptr_bin[0] ^ rptr_bin[1];
    rptr_gray[1] = rptr_bin[1] ^ rptr_bin[2];
    rptr_gray[2] = rptr_bin[2];
end

// Read pointer synchronizer
reg [2:0] rptr_sync_reg;
always @(posedge wclk) begin
    if (~wrstn) begin
        rptr_sync_reg <= 0;
    end else begin
        rptr_sync_reg <= rptr_gray;
    end
end
assign rptr_sync = rptr_sync_reg;

// Write pointer synchronizer
reg [2:0] wptr_sync_reg;
always @(posedge rclk) begin
    if (~rrstn) begin
        wptr_sync_reg <= 0;
    end else begin
        wptr_sync_reg <= wptr_gray;
    end
end
assign wptr_sync = wptr_sync_reg;

// Write pointer increment logic
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc && ~wfull) begin
        ram[wptr_bin] <= wdata;
        wptr_bin <= (wptr_bin + 1) % DEPTH;
    end
end

// Read pointer increment logic
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc && ~rempty) begin
        rdata <= ram[rptr_bin];
        rptr_bin <= (rptr_bin + 1) % DEPTH;
    end
end

// Full and empty signal generation logic
assign wfull = (wptr_gray == {~rptr_sync[2], rptr_sync[1:0]});
assign rempty = (rptr_gray == wptr_sync);

endmodule