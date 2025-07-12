module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire             wclk,      // Write clock signal
    input  wire             rclk,      // Read clock signal
    input  wire             wrstn,     // Write reset signal
    input  wire             rrstn,     // Read reset signal
    input  wire             winc,      // Write increment signal
    input  wire             rinc,      // Read increment signal
    input  wire [WIDTH-1:0] wdata,     // Write data input
    output wire             wfull,     // Write full signal
    output wire             rempty,    // Read empty signal
    output wire [WIDTH-1:0] rdata      // Read data output
);

// Instantiate dual-port RAM module
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) dual_port_RAM_inst (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr),
   .rdata(rdata)
);

// Define registers for write and read pointers
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

// Define registers for Gray code write and read pointers
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_syn;

// Define registers for pointer buffers
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

// Define signals for write and read enables
wire wen;
wire ren;

// Define internal signals for full and empty conditions
wire wfull_int;
wire rempty_int;

// Initialize write and read pointers
initial begin
    waddr_bin = 0;
    raddr_bin = 0;
    wptr = 0;
    rptr = 0;
    rptr_syn = 0;
    wptr_buff = 0;
    rptr_buff = 0;
end

// Increment write pointer on positive edge of write clock
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= gray_code(waddr_bin);
    end
end

// Increment read pointer on positive edge of read clock
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= gray_code(raddr_bin);
    end
end

// Update write pointer buffer
always @(posedge wclk) begin
    wptr_buff <= wptr;
end

// Update read pointer buffer
always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// Synchronize read pointer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Generate full signal
assign wfull_int = (wptr == (~rptr_syn[$clog2(DEPTH)-1] & {rptr_syn[$clog2(DEPTH)-2:0]}));

// Generate empty signal
assign rempty_int = (rptr_syn == wptr);

// Assign full and empty signals to output
assign wfull = wfull_int;
assign rempty = rempty_int;

// Assign write enable signal
assign wen = winc;

// Assign read enable signal
assign ren = rinc;

// Assign write address
assign waddr = waddr_bin[$clog2(DEPTH)-2:0];

// Assign read address
assign raddr = raddr_bin[$clog2(DEPTH)-2:0];

// Function to convert binary to Gray code
function [$clog2(DEPTH)-1:0] gray_code;
    input [$clog2(DEPTH)-1:0] bin;
    begin
        gray_code = bin ^ (bin >> 1);
    end
endfunction

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire             wclk,      // Write clock signal
    input  wire             wenc,      // Write enable signal
    input  wire [$clog2(DEPTH)-2:0] waddr,  // Write address
    input  wire [WIDTH-1:0] wdata,     // Write data input
    input  wire             rclk,      // Read clock signal
    input  wire             renc,      // Read enable signal
    input  wire [$clog2(DEPTH)-2:0] raddr,  // Read address
    output wire [WIDTH-1:0] rdata      // Read data output
);

// Define 2D array to store data
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Initialize RAM
initial begin
    for (int i = 0; i < DEPTH; i++) begin
        RAM_MEM[i] = 0;
    end
end

// Write data to RAM
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read data from RAM
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule