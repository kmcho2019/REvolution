module asyn_fifo (
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

parameter DEPTH = 16;
parameter WIDTH = 8;

// Calculate the address width
parameter ADDR_WIDTH = $clog2(DEPTH);

// Dual-port RAM
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write pointer
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] wptr;

// Read pointer
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] rptr_buff;
reg [ADDR_WIDTH-1:0] rptr_syn;

// Write pointer synchronization
reg [ADDR_WIDTH-1:0] wptr_sync;
reg [ADDR_WIDTH-1:0] wptr_sync_reg;

// Read pointer synchronization
reg [ADDR_WIDTH-1:0] rptr_sync_reg;
reg [ADDR_WIDTH-1:0] rptr_sync;

// Gray code conversion
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;

// Flags
reg wfull_reg;
reg rempty_reg;

// Dual-port RAM instantiation
assign rdata = RAM_MEM[raddr_bin];

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Write pointer Gray code conversion
always @(posedge wclk) begin
    wptr_gray[ADDR_WIDTH-1:1] <= waddr_bin[ADDR_WIDTH-1:1];
    wptr_gray[0] <= waddr_bin[ADDR_WIDTH-1] ^ waddr_bin[ADDR_WIDTH-2];
end

// Read pointer Gray code conversion
always @(posedge rclk) begin
    rptr_gray[ADDR_WIDTH-1:1] <= raddr_bin[ADDR_WIDTH-1:1];
    rptr_gray[0] <= raddr_bin[ADDR_WIDTH-1] ^ raddr_bin[ADDR_WIDTH-2];
end

// Write pointer synchronization
always @(posedge wclk) begin
    wptr_buff <= wptr_gray;
end

always @(posedge rclk) begin
    wptr_sync_reg <= wptr_buff;
    wptr_sync <= wptr_sync_reg;
end

// Read pointer synchronization
always @(posedge rclk) begin
    rptr_buff <= rptr_gray;
end

always @(posedge wclk) begin
    rptr_sync_reg <= rptr_buff;
    rptr_syn <= rptr_sync_reg;
end

// Full and empty flags
always @(posedge wclk) begin
    if (wptr_sync == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]}) begin
        wfull_reg <= 1'b1;
    end else begin
        wfull_reg <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr_syn == wptr_sync) begin
        rempty_reg <= 1'b1;
    end else begin
        rempty_reg <= 1'b0;
    end
end

// Output assignments
assign wfull = wfull_reg;
assign rempty = rempty_reg;

// RAM write operation
always @(posedge wclk) begin
    if (winc && ~wfull_reg) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

endmodule