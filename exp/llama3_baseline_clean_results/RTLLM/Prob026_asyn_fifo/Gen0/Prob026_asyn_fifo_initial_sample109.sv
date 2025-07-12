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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

// Dual-port RAM
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write and read pointers in binary
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

// Write and read pointers in Gray code
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;

// Buffers for synchronization
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

// Synchronized read pointer
reg [$clog2(DEPTH)-1:0] rptr_syn;

// Full and empty flags
reg wfull_int;
reg rempty_int;

// Write enable and read enable signals
reg wen;
reg ren;

// Instantiate dual-port RAM
always @(posedge wclk) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc && !wfull_int) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc && !rempty_int) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Convert binary to Gray code
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Synchronize write and read pointers
always @(posedge wclk) begin
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr_buff <= rptr_syn;
end

// Two-stage synchronizer for read pointer
reg [$clog2(DEPTH)-1:0] rptr_sync1;
reg [$clog2(DEPTH)-1:0] rptr_sync2;
always @(posedge wclk) begin
    rptr_sync1 <= rptr;
    rptr_sync2 <= rptr_sync1;
    rptr_syn <= rptr_sync2;
end

// Two-stage synchronizer for write pointer
reg [$clog2(DEPTH)-1:0] wptr_sync1;
reg [$clog2(DEPTH)-1:0] wptr_sync2;
always @(posedge rclk) begin
    wptr_sync1 <= wptr;
    wptr_sync2 <= wptr_sync1;
end

// Full and empty detection
always @(posedge wclk) begin
    if (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull_int <= 1;
    end else begin
        wfull_int <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr == wptr_sync2) begin
        rempty_int <= 1;
    end else begin
        rempty_int <= 0;
    end
end

// Generate write enable and read enable signals
always @(posedge wclk) begin
    if (winc && !wfull_int) begin
        wen <= 1;
    end else begin
        wen <= 0;
    end
end

always @(posedge rclk) begin
    if (rinc && !rempty_int) begin
        ren <= 1;
    end else begin
        ren <= 0;
    end
end

// Write data into RAM
always @(posedge wclk) begin
    if (wen) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

// Read data from RAM
always @(posedge rclk) begin
    if (ren) begin
        rdata <= RAM_MEM[raddr_bin];
    end
end

assign wfull = wfull_int;
assign rempty = rempty_int;

endmodule