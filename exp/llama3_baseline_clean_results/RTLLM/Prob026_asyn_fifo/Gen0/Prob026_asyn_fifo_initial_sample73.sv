module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

// Define the dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
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
        end
    end
endmodule

// Instantiate the dual-port RAM module
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) RAM (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
);

// Define the write and read pointers
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

// Define the Gray code conversion for the write and read pointers
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_syn;

// Define the full and empty signals
reg wfull;
reg rempty;

// Define the write and read enable signals
reg wen;
reg ren;

// Initialize the write and read pointers
initial begin
    waddr_bin <= 0;
    raddr_bin <= 0;
    wptr <= 0;
    rptr <= 0;
    wptr_buff <= 0;
    rptr_buff <= 0;
    rptr_syn <= 0;
    wfull <= 0;
    rempty <= 0;
    wen <= 0;
    ren <= 0;
end

// Increment the write pointer
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end
    else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Increment the read pointer
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end
    else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Convert the write pointer to Gray code
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

// Convert the read pointer to Gray code
always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Update the write pointer buffer
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end
    else begin
        wptr_buff <= wptr;
    end
end

// Update the read pointer buffer
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end
    else begin
        rptr_buff <= rptr;
    end
end

// Update the synchronized read pointer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Determine if the FIFO is full
always @(posedge wclk) begin
    if (wptr == ({~rptr_syn[$clog2(DEPTH)-1:1], rptr_syn[0]})) begin
        wfull <= 1;
    end
    else begin
        wfull <= 0;
    end
end

// Determine if the FIFO is empty
always @(posedge rclk) begin
    if (rptr == wptr_buff) begin
        rempty <= 1;
    end
    else begin
        rempty <= 0;
    end
end

// Control the write enable signal
always @(posedge wclk) begin
    if (~wrstn) begin
        wen <= 0;
    end
    else if (winc && ~wfull) begin
        wen <= 1;
    end
    else begin
        wen <= 0;
    end
end

// Control the read enable signal
always @(posedge rclk) begin
    if (~rrstn) begin
        ren <= 0;
    end
    else if (rinc && ~rempty) begin
        ren <= 1;
    end
    else begin
        ren <= 0;
    end
end

// Assign the write address
assign waddr = waddr_bin[$clog2(DEPTH)-2:0];

// Assign the read address
assign raddr = raddr_bin[$clog2(DEPTH)-2:0];

endmodule