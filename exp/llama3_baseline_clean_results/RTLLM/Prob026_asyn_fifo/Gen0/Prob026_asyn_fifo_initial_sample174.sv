module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,      // Write clock signal
    input  logic             rclk,      // Read clock signal
    input  logic             wrstn,     // Write reset signal
    input  logic             rrstn,     // Read reset signal
    input  logic             winc,      // Write increment signal
    input  logic             rinc,      // Read increment signal
    input  logic [WIDTH-1:0] wdata,     // Write data input
    output logic             wfull,     // Write full signal
    output logic             rempty,    // Read empty signal
    output logic [WIDTH-1:0] rdata      // Read data output
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,      // Write clock signal
    input  logic             wenc,      // Write enable signal
    input  logic [$clog2(DEPTH)-1:0] waddr,  // Write address
    input  logic [WIDTH-1:0] wdata,     // Write data input
    input  logic             rclk,      // Read clock signal
    input  logic             renc,      // Read enable signal
    input  logic [$clog2(DEPTH)-1:0] raddr,  // Read address
    output logic [WIDTH-1:0] rdata      // Read data output
);

    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always_ff @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always_ff @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule

// Instantiate the dual-port RAM module
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) RAM_inst (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr),
   .rdata(rdata)
);

// Write and read pointers
logic [$clog2(DEPTH)-1:0] waddr_bin;
logic [$clog2(DEPTH)-1:0] raddr_bin;

always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= '0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= '0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
logic [$clog2(DEPTH)-1:0] wptr;
logic [$clog2(DEPTH)-1:0] rptr;

always_comb begin
    wptr = waddr_bin ^ (waddr_bin >> 1);
    rptr = raddr_bin ^ (raddr_bin >> 1);
end

// Pointer buffers
logic [$clog2(DEPTH)-1:0] wptr_buff;
logic [$clog2(DEPTH)-1:0] rptr_buff;

always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_buff <= '0;
    end else begin
        wptr_buff <= wptr;
    end
end

always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_buff <= '0;
    end else begin
        rptr_buff <= rptr;
    end
end

// Full and empty signals
logic wfull_int;
logic rempty_int;

always_comb begin
    wfull_int = (wptr_buff == (~rptr_buff[$clog2(DEPTH)-1] & rptr_buff[$clog2(DEPTH)-2:0]));
    rempty_int = (rptr_buff == wptr_buff);
end

assign wfull = wfull_int;
assign rempty = rempty_int;

// Input and output connections
logic wen;
logic ren;
logic [$clog2(DEPTH)-1:0] waddr;
logic [$clog2(DEPTH)-1:0] raddr;

assign wen = winc;
assign ren = rinc;
assign waddr = waddr_bin[$clog2(DEPTH)-1:1];
assign raddr = raddr_bin[$clog2(DEPTH)-1:1];

endmodule