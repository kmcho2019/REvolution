module asyn_fifo(
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

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [WIDTH-1:0] rdata_reg;
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] waddr_bin_buff;
reg [$clog2(DEPTH)-1:0] raddr_bin_buff;
reg [3:0] wptr;
reg [3:0] rptr;
reg [3:0] wptr_buff;
reg [3:0] rptr_buff;
reg wfull_reg;
reg rempty_reg;
reg wenc;
reg renc;

// Write pointer management
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer management
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(waddr_bin) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-1] ^ waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-2] ^ waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-3] ^ waddr_bin[$clog2(DEPTH)-4]};
end

always @(raddr_bin) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-1] ^ raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-2] ^ raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-3] ^ raddr_bin[$clog2(DEPTH)-4]};
end

// Pointer buffers
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr;
    end
end

// Full and empty signal generation
always @(posedge wclk or posedge rclk) begin
    wfull_reg <= (wptr_buff == (~rptr_buff[3] & rptr_buff[2:0]));
    rempty_reg <= (rptr_buff == wptr_buff);
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

// Dual-port RAM
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata_reg <= RAM_MEM[raddr_bin];
    end
end

assign rdata = rdata_reg;

// Control signals
always @(posedge wclk) begin
    wenc <= winc;
end

always @(posedge rclk) begin
    renc <= rinc;
end

endmodule