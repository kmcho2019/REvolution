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

reg [WIDTH-1:0] dpram [DEPTH-1:0];

reg [($clog2(DEPTH))-1:0] waddr_bin;
reg [($clog2(DEPTH))-1:0] raddr_bin;
reg [($clog2(DEPTH))-1:0] wptr;
reg [($clog2(DEPTH))-1:0] rptr;
reg [($clog2(DEPTH))-1:0] wptr_sync;
reg [($clog2(DEPTH))-1:0] rptr_sync;

// Gray code conversion and pointer update
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= waddr_bin ^ (waddr_bin >> 1);
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= raddr_bin ^ (raddr_bin >> 1);
    end
end

// Two-stage synchronizers
reg [($clog2(DEPTH))-1:0] wptr_sync_temp;
always @(posedge rclk) begin
    wptr_sync_temp <= wptr;
    wptr_sync <= wptr_sync_temp;
end

reg [($clog2(DEPTH))-1:0] rptr_sync_temp;
always @(posedge wclk) begin
    rptr_sync_temp <= rptr;
    rptr_sync <= rptr_sync_temp;
end

// Full and empty signal generation
always @(posedge wclk) begin
    if (~wrstn) begin
        wfull <= 0;
    end else if ((wptr_sync[($clog2(DEPTH))-1]!= rptr[($clog2(DEPTH))-1]) && (wptr_sync[($clog2(DEPTH))-2:0] == rptr[($clog2(DEPTH))-2:0])) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty <= 1;
    end else if (rptr == wptr_sync) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Write operation
always @(posedge wclk) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        dpram[waddr_bin] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= dpram[raddr_bin];
    end
end

endmodule