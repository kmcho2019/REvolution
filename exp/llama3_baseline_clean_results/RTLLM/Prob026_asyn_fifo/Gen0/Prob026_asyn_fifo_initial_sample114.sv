// Dual-port RAM module
module dual_port_RAM(
    input         wclk,     // Write clock
    input         wenc,     // Write enable
    input  [$clog2(DEPTH)-1:0] waddr,  // Write address
    input  [WIDTH-1:0] wdata,  // Write data
    input         rclk,     // Read clock
    input         renc,     // Read enable
    input  [$clog2(DEPTH)-1:0] raddr,  // Read address
    output reg [WIDTH-1:0] rdata     // Read data
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

// Asynchronous FIFO module
module asyn_fifo(
    input         wclk,     // Write clock
    input         rclk,     // Read clock
    input         wrstn,    // Write reset
    input         rrstn,    // Read reset
    input         winc,     // Write increment
    input         rinc,     // Read increment
    input  [WIDTH-1:0] wdata,  // Write data
    output reg    wfull,    // Write full
    output reg    rempty,   // Read empty
    output reg [WIDTH-1:0] rdata  // Read data
);

parameter DEPTH = 16;
parameter WIDTH = 8;

reg [$clog2(DEPTH)-1:0] waddr_bin;  // Binary write address
reg [$clog2(DEPTH)-1:0] raddr_bin;  // Binary read address
reg [$clog2(DEPTH)-1:0] wptr_bin;  // Binary write pointer
reg [$clog2(DEPTH)-1:0] rptr_bin;  // Binary read pointer
reg [$clog2(DEPTH)-1:0] wptr_syn;  // Synchronized binary write pointer
reg [$clog2(DEPTH)-1:0] rptr_syn;  // Synchronized binary read pointer
reg [WIDTH-1:0] wdata_reg;  // Write data register

wire wenc;  // Write enable
wire renc;  // Read enable

// Gray code conversion
function [3:0] gray_code(reg [3:0] bin);
    gray_code = bin ^ (bin >> 1);
endfunction

function [3:0] bin_code(reg [3:0] gray);
    bin_code = gray ^ (gray >> 1);
endfunction

// Dual-port RAM instantiation
dual_port_RAM u_dual_port_RAM(
    .wclk(wclk),
    .wenc(wenc),
    .waddr(wptr_bin[$clog2(DEPTH)-1:1]),
    .wdata(wdata_reg),
    .rclk(rclk),
    .renc(renc),
    .raddr(rptr_bin[$clog2(DEPTH)-1:1]),
    .rdata(rdata)
);

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

assign wenc = winc;

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

assign renc = rinc;

// Write pointer synchronizer
reg [1:0] wptr_syn_reg;
always @(posedge rclk) begin
    wptr_syn_reg <= {wptr_syn_reg[0], waddr_bin[0]};
end
assign wptr_syn = wptr_syn_reg;

// Read pointer synchronizer
reg [1:0] rptr_syn_reg;
always @(posedge wclk) begin
    rptr_syn_reg <= {rptr_syn_reg[0], raddr_bin[0]};
end
assign rptr_syn = rptr_syn_reg;

// Full and empty signals
assign wfull = (wptr_syn == {~rptr_syn[3], rptr_syn[2:0]});
assign rempty = (rptr_syn == wptr_syn);

// Data write register
always @(posedge wclk) begin
    wdata_reg <= wdata;
end

endmodule