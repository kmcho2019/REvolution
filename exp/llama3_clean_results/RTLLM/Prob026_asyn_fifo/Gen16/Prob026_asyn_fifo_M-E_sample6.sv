module echo_fifo #(
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

// Write FIFO (WFIFO)
reg [WIDTH-1:0] wfifo [DEPTH-1:0];
reg [WIDTH-1:0] wfifo_out;
reg [DEPTH-1:0] wptr;
reg [DEPTH-1:0] wcnt;

// Read FIFO (RFIFO)
reg [WIDTH-1:0] rfifo [DEPTH-1:0];
reg [WIDTH-1:0] rfifo_out;
reg [DEPTH-1:0] rptr;
reg [DEPTH-1:0] rcnt;

// Clock Domain Crossing (CDC) Module
reg token;
reg [WIDTH-1:0] cdc_data;

// Write FIFO Controller
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
        wcnt <= 0;
    end else if (winc && ~wfull) begin
        wfifo[wptr] <= wdata;
        wptr <= (wptr + 1) % DEPTH;
        wcnt <= wcnt + 1;
        token <= 1;
    end
end

// Read FIFO Controller
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
        rcnt <= 0;
    end else if (rinc && ~rempty) begin
        rfifo_out <= rfifo[rptr];
        rptr <= (rptr + 1) % DEPTH;
        rcnt <= rcnt - 1;
    end
end

// Clock Domain Crossing (CDC) Module
always @(posedge wclk) begin
    if (token) begin
        cdc_data <= wfifo_out;
        token <= 0;
    end
end

always @(posedge rclk) begin
    if (~rempty) begin
        rfifo[rcnt] <= cdc_data;
        rcnt <= rcnt + 1;
    end
end

// Full and Empty Signal Generation
assign wfull = (wcnt == DEPTH);
assign rempty = (rcnt == 0);

// Output Assignment
assign rdata = rfifo_out;

endmodule