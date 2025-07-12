module asyn_fifo(
    input  wclk,     // Write clock signal
    input  rclk,     // Read clock signal
    input  wrstn,    // Write reset signal (0: reset, 1: no reset)
    input  rrstn,    // Read reset signal (0: reset, 1: no reset)
    input  winc,     // Write increment signal
    input  rinc,     // Read increment signal
    input  [WIDTH-1:0] wdata, // Write data input
    output wfull,    // Write full signal
    output rempty,   // Read empty signal
    output [WIDTH-1:0] rdata  // Read data output
);

// Define parameters for FIFO depth and width
parameter WIDTH = 8;
parameter DEPTH = 16;

// Calculate log2 of DEPTH for address width
parameter ADDR_WIDTH = $clog2(DEPTH);

// Dual-port RAM module
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) ram_inst (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr_bin),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr_bin),
   .rdata(rdata)
);

// Write pointer binary register
reg [ADDR_WIDTH-1:0] waddr_bin;
// Read pointer binary register
reg [ADDR_WIDTH-1:0] raddr_bin;

// Write pointer Gray code register
reg [ADDR_WIDTH-1:0] wptr;
// Read pointer Gray code register
reg [ADDR_WIDTH-1:0] rptr;

// Write pointer buffer register
reg [ADDR_WIDTH-1:0] wptr_buff;
// Read pointer buffer register
reg [ADDR_WIDTH-1:0] rptr_buff;

// Write enable signal
reg wen;
// Read enable signal
reg ren;

// Write clock domain
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
        wptr_buff <= 0;
    end else begin
        if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr <= waddr_bin ^ (waddr_bin >> 1);
        end
        wptr_buff <= wptr;
    end
end

// Read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
        rptr_buff <= 0;
    end else begin
        if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr <= raddr_bin ^ (raddr_bin >> 1);
        end
        rptr_buff <= rptr;
    end
end

// Write pointer synchronizer (two-stage trigger)
always @(posedge rclk) begin
    rptr_syn <= wptr_buff;
end

// Read pointer synchronizer (two-stage trigger)
always @(posedge wclk) begin
    wptr_syn <= rptr_buff;
end

// Empty and full signal generation
always @(posedge wclk) begin
    if (wptr_syn == rptr_syn) begin
        wfull <= 1'b1;
    end else begin
        wfull <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr_syn == wptr_syn) begin
        rempty <= 1'b1;
    end else begin
        rempty <= 1'b0;
    end
end

// Write enable signal generation
always @(posedge wclk) begin
    if (winc) begin
        wen <= 1'b1;
    end else begin
        wen <= 1'b0;
    end
end

// Read enable signal generation
always @(posedge rclk) begin
    if (rinc) begin
        ren <= 1'b1;
    end else begin
        ren <= 1'b0;
    end
end

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wclk,     // Write clock signal
    input  wenc,     // Write enable signal
    input  [ADDR_WIDTH-1:0] waddr, // Write address input
    input  [WIDTH-1:0] wdata, // Write data input
    input  rclk,     // Read clock signal
    input  renc,     // Read enable signal
    input  [ADDR_WIDTH-1:0] raddr, // Read address input
    output [WIDTH-1:0] rdata  // Read data output
);

// Define address width based on DEPTH
parameter ADDR_WIDTH = $clog2(DEPTH);

// RAM memory array
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write operation
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule