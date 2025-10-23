// Ping-Pong Buffer Module
module ping_pong_buffer #(
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

reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

reg [WIDTH-1:0] buffer1 [DEPTH-1:0];
reg [WIDTH-1:0] buffer2 [DEPTH-1:0];

reg wbuffer_select;
reg rbuffer_select;

reg wvalid;
reg rvalid;

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
        wvalid <= 0;
    end else if (winc) begin
        wptr <= (wptr + 1) % DEPTH;
        wvalid <= 1;
    end
end

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
        rvalid <= 0;
    end else if (rinc) begin
        rptr <= (rptr + 1) % DEPTH;
        rvalid <= 1;
    end
end

// Write data to ping-pong buffers
always @(posedge wclk) begin
    if (wvalid) begin
        if (wbuffer_select) begin
            buffer1[wptr] <= wdata;
        end else begin
            buffer2[wptr] <= wdata;
        end
    end
end

// Read data from ping-pong buffers
always @(posedge rclk) begin
    if (rvalid) begin
        if (rbuffer_select) begin
            rdata <= buffer1[rptr];
        end else begin
            rdata <= buffer2[rptr];
        end
    end
end

// Dual-clock handshake protocol
always @(posedge wclk) begin
    if (wvalid) begin
        wbuffer_select <= ~wbuffer_select;
    end
end

always @(posedge rclk) begin
    if (rvalid) begin
        rbuffer_select <= ~rbuffer_select;
    end
end

// Full and empty signal generation
assign wfull = (wptr == (rptr + 1) % DEPTH);
assign rempty = (rptr == wptr);

endmodule