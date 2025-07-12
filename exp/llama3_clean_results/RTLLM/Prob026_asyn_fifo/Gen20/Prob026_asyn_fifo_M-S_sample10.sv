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

reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [WIDTH-1:0] rdata_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
        wfull <= 0;
    end else if (winc && ~wfull) begin
        ram[wptr] <= wdata;
        wptr <= (wptr + 1) % DEPTH;
        if (wptr == (rptr + 1) % DEPTH) begin
            wfull <= 1;
        end else begin
            wfull <= 0;
        end
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
        rempty <= 1;
    end else if (rinc && ~rempty) begin
        rdata_reg <= ram[rptr];
        rptr <= (rptr + 1) % DEPTH;
        if (rptr == wptr) begin
            rempty <= 1;
        end else begin
            rempty <= 0;
        end
    end
end

assign rdata = rdata_reg;

endmodule