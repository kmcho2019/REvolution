module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wclk,  // Write clock
    input  rclk,  // Read clock
    input  wrstn, // Write reset (active low)
    input  rrstn, // Read reset (active low)
    input  winc,  // Write increment
    input  rinc,  // Read increment
    input  [WIDTH-1:0] wdata, // Write data
    output [WIDTH-1:0] rdata, // Read data
    output wfull, // Write full
    output rempty  // Read empty
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wclk,  // Write clock
    input  wenc,  // Write enable
    input  [$clog2(DEPTH)-1:0] waddr, // Write address
    input  [WIDTH-1:0] wdata, // Write data
    input  rclk,  // Read clock
    input  renc,  // Read enable
    input  [$clog2(DEPTH)-1:0] raddr, // Read address
    output reg [WIDTH-1:0] rdata  // Read data
);

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    reg [WIDTH-1:0] temp;

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            temp <= RAM_MEM[raddr];
            rdata <= temp;
        end
    end

endmodule

// Asynchronous FIFO module
reg [WIDTH-1:0] rdata_reg;
reg wfull_reg;
reg rempty_reg;

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;

reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn;

reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

wire wen;
wire ren;

assign wen = winc && !wfull_reg;
assign ren = rinc && !rempty_reg;

// Dual-port RAM instantiation
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) u_ram (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr_bin),
    .rdata(rdata_reg)
);

// Write pointer logic
always @(posedge wclk) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (wen) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-4]} ^ 
            {1'b0, waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-4]};
end

// Read pointer logic
always @(posedge rclk) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (ren) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge rclk) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-4]} ^ 
            {1'b0, raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-4]};
end

// Read pointer synchronizer
always @(posedge wclk) begin
    wptr_syn <= wptr;
end

always @(posedge wclk) begin
    rptr_syn <= rptr;
end

// Write pointer synchronizer
always @(posedge rclk) begin
    wptr_buff <= wptr_syn;
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// Empty and full detection
always @(posedge wclk or posedge rclk) begin
    if (wptr_syn == {~rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-2], rptr_buff[$clog2(DEPTH)-3], rptr_buff[$clog2(DEPTH)-4]}) begin
        wfull_reg <= 1'b1;
    end else begin
        wfull_reg <= 1'b0;
    end
end

always @(posedge wclk or posedge rclk) begin
    if (rptr == wptr_syn) begin
        rempty_reg <= 1'b1;
    end else begin
        rempty_reg <= 1'b0;
    end
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;
assign rdata = rdata_reg;

endmodule