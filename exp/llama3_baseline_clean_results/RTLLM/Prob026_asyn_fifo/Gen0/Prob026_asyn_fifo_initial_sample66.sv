module dual_port_RAM(
    input   wclk,    // Write clock signal
    input   wenc,    // Write enable signal
    input   [$clog2($param(DEPTH))-1:0] waddr,  // Write address
    input   [WIDTH-1:0] wdata,  // Write data
    input   rclk,    // Read clock signal
    input   renc,    // Read enable signal
    input   [$clog2($param(DEPTH))-1:0] raddr,  // Read address
    output reg [WIDTH-1:0] rdata  // Read data
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];  // RAM memory

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

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input   wclk,    // Write clock signal
    input   rclk,    // Read clock signal
    input   wrstn,   // Write reset signal
    input   rrstn,   // Read reset signal
    input   winc,    // Write increment signal
    input   rinc,    // Read increment signal
    input   [WIDTH-1:0] wdata,  // Write data
    output  wfull,   // Write full signal
    output  rempty,  // Read empty signal
    output  [WIDTH-1:0] rdata  // Read data
);

reg [$clog2(DEPTH)-1:0] waddr_bin;  // Binary write address
reg [$clog2(DEPTH)-1:0] raddr_bin;  // Binary read address
reg [$clog2(DEPTH)-1:0] wptr;  // Write pointer (Gray code)
reg [$clog2(DEPTH)-1:0] rptr;  // Read pointer (Gray code)
reg [$clog2(DEPTH)-1:0] wptr_buff;  // Buffer for write pointer
reg [$clog2(DEPTH)-1:0] rptr_buff;  // Buffer for read pointer
reg [WIDTH-1:0] rdata_reg;  // Registered read data

wire wen;  // Write enable signal
wire ren;  // Read enable signal

assign wen = winc & ~wfull;
assign ren = rinc & ~rempty;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end
    else if (wen) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end
    else if (ren) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
    rptr_buff <= rptr;
end

assign wfull = (wptr == {~rptr[$clog2(DEPTH)-1], rptr[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr);

dual_port_RAM #(.WIDTH(WIDTH),.DEPTH(DEPTH)) dual_port_RAM_inst (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr_bin[$clog2(DEPTH)-2:0]),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr_bin[$clog2(DEPTH)-2:0]),
   .rdata(rdata_reg)
);

assign rdata = rdata_reg;

endmodule