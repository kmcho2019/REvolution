module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
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

localparam ADDR_WIDTH = $clog2(DEPTH);

// Token Ring
reg [WIDTH-1:0] token_ring [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

// Write Controller
reg wempty;
reg wfull_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
        wempty <= 1;
        wfull_reg <= 0;
    end else if (winc && ~wfull_reg) begin
        token_ring[wptr] <= wdata;
        wptr <= wptr + 1;
        wempty <= 0;
        if (wptr == DEPTH - 1) begin
            wfull_reg <= 1;
        end
    end
end

// Read Controller
reg rempty_reg;
reg rfull;

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
        rempty_reg <= 1;
        rfull <= 0;
    end else if (rinc && ~rempty_reg) begin
        rdata <= token_ring[rptr];
        rptr <= rptr + 1;
        rempty_reg <= 0;
        if (rptr == DEPTH - 1) begin
            rfull <= 1;
        end
    end
end

// Token Manager
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;

always @(posedge wclk) begin
    wptr_gray <= wptr ^ (wptr >> 1);
end

always @(posedge rclk) begin
    rptr_gray <= rptr ^ (rptr >> 1);
end

// Full and empty signals
assign wfull = wfull_reg;
assign rempty = rempty_reg;

// Two-stage synchronizer for write pointer
reg [ADDR_WIDTH-1:0] wptr_sync1;
reg [ADDR_WIDTH-1:0] wptr_sync2;

always @(posedge rclk) begin
    wptr_sync1 <= wptr_gray;
    wptr_sync2 <= wptr_sync1;
end

// Two-stage synchronizer for read pointer
reg [ADDR_WIDTH-1:0] rptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync2;

always @(posedge wclk) begin
    rptr_sync1 <= rptr_gray;
    rptr_sync2 <= rptr_sync1;
end

// Full condition
always @(*) begin
    if (wptr_sync2 == (rptr_sync2 ^ {1'b1, {ADDR_WIDTH-1{1'b0}}})) begin
        wfull_reg <= 1;
    end else begin
        wfull_reg <= 0;
    end
end

// Empty condition
always @(*) begin
    if (rptr_sync2 == wptr_sync2) begin
        rempty_reg <= 1;
    end else begin
        rempty_reg <= 0;
    end
end

endmodule