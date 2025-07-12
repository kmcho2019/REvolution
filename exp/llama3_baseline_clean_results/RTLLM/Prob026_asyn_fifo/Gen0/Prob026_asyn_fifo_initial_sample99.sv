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

// Dual-port RAM
reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
reg [WIDTH-1:0] rdata_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        RAM_MEM[0] <= 0;
    end else if (winc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rdata_reg <= 0;
    end else if (rinc) begin
        rdata_reg <= RAM_MEM[raddr];
    end
end

assign rdata = rdata_reg;

// Write and Read Pointers
reg [$clog2(DEPTH)-1:0] waddr;
reg [$clog2(DEPTH)-1:0] raddr;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr <= 0;
    end else if (winc) begin
        waddr <= waddr + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr <= 0;
    end else if (rinc) begin
        raddr <= raddr + 1;
    end
end

// Gray Code Conversion
reg [3:0] wptr;
reg [3:0] rptr;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= (waddr[1:0] ^ (waddr[2:1] >> 1));
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= (raddr[1:0] ^ (raddr[2:1] >> 1));
    end
end

// Pointer Buffers
reg [3:0] wptr_buff;
reg [3:0] rptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr;
    end
end

// Full and Empty Signals
reg wfull_reg;
reg rempty_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        wfull_reg <= 0;
    end else begin
        if ((wptr[3] == ~rptr_buff[3]) && (wptr[2:0] == rptr_buff[2:0])) begin
            wfull_reg <= 1;
        end else begin
            wfull_reg <= 0;
        end
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty_reg <= 0;
    end else begin
        if (rptr == wptr_buff) begin
            rempty_reg <= 1;
        end else begin
            rempty_reg <= 0;
        end
    end
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

endmodule