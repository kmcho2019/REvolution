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

localparam ADDR_WIDTH = $clog2(DEPTH);
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] wptr, rptr;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= (wptr + 1) % DEPTH;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= (rptr + 1) % DEPTH;
    end
end

always @(posedge wclk) begin
    if (winc) begin
        RAM_MEM[wptr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (rinc) begin
        rdata <= RAM_MEM[rptr];
    end
end

wire wptr_gray = (wptr >> 1) ^ wptr;
reg rptr_gray;
always @(posedge rclk) begin
    rptr_gray <= (rptr >> 1) ^ rptr;
end

assign wfull = (wptr_gray == ((rptr + 1) % DEPTH >> 1) ^ ((rptr + 1) % DEPTH));
assign rempty = (wptr == rptr);

endmodule