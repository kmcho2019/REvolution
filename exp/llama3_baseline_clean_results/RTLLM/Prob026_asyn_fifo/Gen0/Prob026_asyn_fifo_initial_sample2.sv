module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,  // Write clock signal
    input  rclk,  // Read clock signal
    input  wrstn, // Write reset signal
    input  rrstn, // Read reset signal
    input  winc,  // Write increment signal
    input  rinc,  // Read increment signal
    input  [WIDTH-1:0] wdata, // Write data input
    output reg wfull, // Write full signal
    output reg rempty, // Read empty signal
    output reg [WIDTH-1:0] rdata // Read data output
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  wclk,  // Write clock signal
    input  wenc,  // Write enable signal
    input  [$clog2(DEPTH)-1:0] waddr, // Write address
    input  [WIDTH-1:0] wdata, // Write data
    input  rclk,  // Read clock signal
    input  renc,  // Read enable signal
    input  [$clog2(DEPTH)-1:0] raddr, // Read address
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
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
);

// Write pointer logic
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [2:0] wptr; // Gray code write pointer
reg [2:0] wptr_buff; // Buffer for write pointer
always @(posedge wclk) begin
    if (!wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-2] ^ waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-3] ^ waddr_bin[$clog2(DEPTH)-2]};
    end
    wptr_buff <= wptr;
end

// Read pointer logic
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [2:0] rptr; // Gray code read pointer
reg [2:0] rptr_syn; // Synchronized read pointer
reg [2:0] rptr_buff; // Buffer for read pointer
always @(posedge rclk) begin
    if (!rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-2] ^ raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-3] ^ raddr_bin[$clog2(DEPTH)-2]};
    end
    rptr_buff <= rptr;
end
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Full and empty signals
always @(*) begin
    wfull <= (wptr == {~rptr_syn[2], rptr_syn[1], rptr_syn[0]});
    rempty <= (rptr == wptr);
end

// Input and output connections
reg wen, ren;
always @(*) begin
    wen <= winc && !wfull;
    ren <= rinc && !rempty;
end
assign waddr = waddr_bin[$clog2(DEPTH)-1:0];
assign raddr = raddr_bin[$clog2(DEPTH)-1:0];

endmodule