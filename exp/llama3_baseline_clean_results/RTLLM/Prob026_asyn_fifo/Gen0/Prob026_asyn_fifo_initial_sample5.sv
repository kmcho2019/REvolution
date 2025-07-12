module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,        // Write clock signal
    input  rclk,        // Read clock signal
    input  wrstn,       // Write reset signal (0 for reset, 1 for no reset)
    input  rrstn,       // Read reset signal (0 for reset, 1 for no reset)
    input  winc,        // Write increment signal
    input  rinc,        // Read increment signal
    input  [WIDTH-1:0] wdata,  // Write data input
    output reg  wfull,   // Write full signal
    output reg  rempty,  // Read empty signal
    output reg [WIDTH-1:0] rdata  // Read data output
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,        // Write clock signal
    input  wenc,        // Write enable signal
    input  [$clog2(DEPTH)-1:0] waddr,  // Write address
    input  [WIDTH-1:0] wdata,  // Write data input
    input  rclk,        // Read clock signal
    input  renc,        // Read enable signal
    input  [$clog2(DEPTH)-1:0] raddr,  // Read address
    output reg [WIDTH-1:0] rdata  // Read data output
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

// Write pointer logic
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [2:0] wptr;
reg [2:0] wptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end
    else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= wptr;
        wptr <= {waddr_bin[2], waddr_bin[1] ^ waddr_bin[0], waddr_bin[0]};
    end
    else begin
        wptr_buff <= wptr;
    end
end

// Read pointer logic
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [2:0] rptr;
reg [2:0] rptr_buff;
reg [2:0] rptr_syn;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end
    else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= rptr;
        rptr <= {raddr_bin[2], raddr_bin[1] ^ raddr_bin[0], raddr_bin[0]};
    end
    else begin
        rptr_buff <= rptr;
    end
end

always @(posedge rclk) begin
    rptr_syn <= rptr;
end

// Empty and full signals
always @(*) begin
    if (wptr_buff == rptr_syn) begin
        wfull <= 1'b1;
    end
    else begin
        wfull <= 1'b0;
    end

    if (rptr == wptr_buff) begin
        rempty <= 1'b1;
    end
    else begin
        rempty <= 1'b0;
    end
end

// Input and output connections
reg wen;
reg ren;

always @(*) begin
    if (winc && ~wfull) begin
        wen <= 1'b1;
    end
    else begin
        wen <= 1'b0;
    end

    if (rinc && ~rempty) begin
        ren <= 1'b1;
    end
    else begin
        ren <= 1'b0;
    end
end

assign waddr = waddr_bin[2:0];
assign raddr = raddr_bin[2:0];

endmodule