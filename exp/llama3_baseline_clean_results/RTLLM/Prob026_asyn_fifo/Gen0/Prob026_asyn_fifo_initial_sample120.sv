module asyn_fifo(
    input wclk, // Write clock
    input rclk, // Read clock
    input wrstn, // Write reset (active low)
    input rrstn, // Read reset (active low)
    input winc, // Write increment signal
    input rinc, // Read increment signal
    input [WIDTH-1:0] wdata, // Write data input
    output wfull, // Write full signal
    output rempty, // Read empty signal
    output [WIDTH-1:0] rdata // Read data output
);

parameter DEPTH = 16;
parameter WIDTH = 8;
parameter ADDR_WIDTH = $clog2(DEPTH);

// Dual-Port RAM Module
module dual_port_RAM(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
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
    end else begin
        rdata <= 'z;
    end
end

endmodule

// Instantiation of Dual-Port RAM
wire wenc, renc;
reg [ADDR_WIDTH-1:0] waddr, raddr;
dual_port_RAM ram_instance(
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata)
);

// Write and Read Pointer Management
reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= '0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= '0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray Code Conversion
reg [ADDR_WIDTH-1:0] wptr, rptr;
always @(*) begin
    wptr = waddr_bin ^ (waddr_bin >> 1);
    rptr = raddr_bin ^ (raddr_bin >> 1);
end

// Pointer Synchronizers
reg [ADDR_WIDTH-1:0] rptr_syn, wptr_syn;
always @(posedge rclk) begin
    rptr_syn <= wptr;
end

always @(posedge wclk) begin
    wptr_syn <= rptr;
end

// Full and Empty Detection
assign wfull = (wptr == {~rptr[ADDR_WIDTH-1], rptr[ADDR_WIDTH-2:0]});
assign rempty = (rptr == wptr);

// Input and Output Connections
assign wenc = winc;
assign renc = rinc;
assign waddr = waddr_bin[ADDR_WIDTH-2:0];
assign raddr = raddr_bin[ADDR_WIDTH-2:0];

endmodule