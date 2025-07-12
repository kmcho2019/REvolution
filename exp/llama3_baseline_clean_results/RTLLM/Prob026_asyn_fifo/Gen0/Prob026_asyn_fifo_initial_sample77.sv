module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk, // Write clock signal
    input rclk, // Read clock signal
    input wrstn, // Write reset signal
    input rrstn, // Read reset signal
    input winc, // Write increment signal
    input rinc, // Read increment signal
    input [WIDTH-1:0] wdata, // Write data input
    output reg wfull, // Write full signal
    output reg rempty, // Read empty signal
    output reg [WIDTH-1:0] rdata // Read data output
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk, // Write clock signal
    input wenc, // Write enable signal
    input [$clog2(DEPTH)-1:0] waddr, // Write address
    input [WIDTH-1:0] wdata, // Write data
    input rclk, // Read clock signal
    input renc, // Read enable signal
    input [$clog2(DEPTH)-1:0] raddr, // Read address
    output reg [WIDTH-1:0] rdata // Read data
);
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end
endmodule

// Instantiate dual-port RAM module
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) u_ram (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata_out)
);

// Write and read pointers
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

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

// Gray code conversion
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;

always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Pointer buffers
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

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

// Full and empty signals
reg wfull_reg;
reg rempty_reg;

always @(posedge wclk) begin
    wfull_reg <= (wptr == (~rptr_buff[$clog2(DEPTH)-1] & {1'b0, rptr_buff[$clog2(DEPTH)-2:0]}));
end

always @(posedge rclk) begin
    rempty_reg <= (rptr == wptr_buff);
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

// Input and output connections
reg wen;
reg ren;
reg [WIDTH-1:0] rdata_out;

always @(posedge wclk) begin
    if (winc) begin
        wen <= 1'b1;
    end else begin
        wen <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rinc) begin
        ren <= 1'b1;
    end else begin
        ren <= 1'b0;
    end
end

assign waddr = waddr_bin[$clog2(DEPTH)-2:0];
assign raddr = raddr_bin[$clog2(DEPTH)-2:0];
assign rdata = rdata_out;

endmodule