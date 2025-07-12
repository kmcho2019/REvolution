// Dual-port RAM module
module dual_port_RAM(
    input         wclk,    // Write clock signal
    input         wenc,    // Write enable signal
    input  [$clog2(`DEPTH)-1:0] waddr, // Write address
    input  [(`WIDTH)-1:0] wdata, // Write data
    input         rclk,    // Read clock signal
    input         renc,    // Read enable signal
    input  [$clog2(`DEPTH)-1:0] raddr, // Read address
    output reg [(`WIDTH)-1:0] rdata  // Read data
);

reg [(`WIDTH)-1:0] RAM_MEM [0:`DEPTH-1]; // RAM memory

always @(posedge wclk) begin
    if(wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if(renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule

// Asynchronous FIFO module
module asyn_fifo(
    input         wclk,    // Write clock signal
    input         wrstn,   // Write reset signal
    input         rclk,    // Read clock signal
    input         rrstn,   // Read reset signal
    input         winc,    // Write increment signal
    input         rinc,    // Read increment signal
    input  [(`WIDTH)-1:0] wdata, // Write data
    output        wfull,   // Write full signal
    output        rempty, // Read empty signal
    output [(`WIDTH)-1:0] rdata  // Read data
);

// Parameters
parameter WIDTH = 8;
parameter DEPTH = 16;

// Dual-port RAM instantiation
dual_port_RAM #(.WIDTH(WIDTH),.DEPTH(DEPTH)) ram_inst(
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr),
   .rdata(rdata_out)
);

// Write pointer and read pointer
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [(`WIDTH)-1:0] rdata_out;

// Write pointer increment logic
always @(posedge wclk) begin
    if(~wrstn) begin
        waddr_bin <= 0;
    end else if(winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer increment logic
always @(posedge rclk) begin
    if(~rrstn) begin
        raddr_bin <= 0;
    end else if(rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-1:1] ^ waddr_bin[$clog2(DEPTH)-2:0]};
end

always @(posedge rclk) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-1:1] ^ raddr_bin[$clog2(DEPTH)-2:0]};
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_buf1;
reg [$clog2(DEPTH)-1:0] rptr_buf2;

always @(posedge wclk) begin
    rptr_buf1 <= rptr;
end

always @(posedge wclk) begin
    rptr_syn <= rptr_buf1;
end

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_buf1;
reg [$clog2(DEPTH)-1:0] wptr_buf2;

always @(posedge rclk) begin
    wptr_buf1 <= wptr;
end

always @(posedge rclk) begin
    wptr_syn <= wptr_buf1;
end

// Empty and full judgment
assign wfull = (wptr_syn[$clog2(DEPTH)-1] == ~rptr[$clog2(DEPTH)-1]) && (wptr_syn[$clog2(DEPTH)-2:0] == rptr[$clog2(DEPTH)-2:0]);
assign rempty = (rptr_syn == wptr);

// Input and output connections
assign waddr = waddr_bin[$clog2(DEPTH)-1:0];
assign raddr = raddr_bin[$clog2(DEPTH)-1:0];
assign wen = winc;
assign ren = rinc;
assign rdata = rdata_out;

endmodule