module asyn_fifo(
    input  logic               wclk,         // Write clock signal
    input  logic               rclk,         // Read clock signal
    input  logic               wrstn,        // Write reset signal
    input  logic               rrstn,        // Read reset signal
    input  logic               winc,         // Write increment signal
    input  logic               rinc,         // Read increment signal
    input  logic [WIDTH-1:0]    wdata,        // Write data input
    output logic               wfull,        // Write full signal
    output logic               rempty,       // Read empty signal
    output logic [WIDTH-1:0]    rdata         // Read data output
);

parameter WIDTH = 8;
parameter DEPTH = 16;

// Dual-port RAM module
module dual_port_RAM(
    input  logic               wclk,         // Write clock signal
    input  logic               wenc,         // Write enable signal
    input  logic [$clog2(DEPTH)-1:0] waddr,    // Write address
    input  logic [WIDTH-1:0]    wdata,        // Write data
    input  logic               rclk,         // Read clock signal
    input  logic               renc,         // Read enable signal
    input  logic [$clog2(DEPTH)-1:0] raddr,    // Read address
    output logic [WIDTH-1:0]    rdata         // Read data
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

// Asynchronous FIFO module
logic [WIDTH-1:0] rdata_int;
logic wenc, renc;
logic [$clog2(DEPTH)-1:0] waddr, raddr;

// Write pointer binary register
logic [$clog2(DEPTH)-1:0] waddr_bin;
always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer binary register
logic [$clog2(DEPTH)-1:0] raddr_bin;
always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Write pointer Gray code conversion
logic [$clog2(DEPTH)-1:0] wptr;
always_comb begin
    wptr = waddr_bin ^ (waddr_bin >> 1);
end

// Read pointer Gray code conversion
logic [$clog2(DEPTH)-1:0] rptr;
always_comb begin
    rptr = raddr_bin ^ (raddr_bin >> 1);
end

// Write pointer synchronizer
logic [$clog2(DEPTH)-1:0] wptr_syn;
always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_syn <= 0;
    end else begin
        wptr_syn <= wptr;
    end
end

// Read pointer synchronizer
logic [$clog2(DEPTH)-1:0] rptr_syn;
always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        rptr_syn <= 0;
    end else begin
        rptr_syn <= rptr;
    end
end

// Full and empty signals
always_comb begin
    wfull = (wptr == (~rptr_syn[$clog2(DEPTH)-1] & rptr_syn[$clog2(DEPTH)-2:0]));
    rempty = (rptr == wptr_syn);
end

// Dual-port RAM instantiation
dual_port_RAM ram_inst(
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata_int)
);

// Input and output connections
always_comb begin
    waddr = waddr_bin[$clog2(DEPTH)-2:0];
    raddr = raddr_bin[$clog2(DEPTH)-2:0];
    wenc = winc;
    renc = rinc;
    rdata = rdata_int;
end

endmodule