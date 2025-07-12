module asyn_fifo
#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input  wire            wclk,       // Write clock signal
    input  wire            rclk,       // Read clock signal
    input  wire            wrstn,      // Write reset signal (0 for reset, 1 for reset inactive)
    input  wire            rrstn,      // Read reset signal (0 for reset, 1 for reset inactive)
    input  wire            winc,       // Write increment signal
    input  wire            rinc,       // Read increment signal
    input  wire [WIDTH-1:0] wdata,     // Write data input
    output reg             wfull,      // Write full signal
    output reg             rempty,     // Read empty signal
    output reg [WIDTH-1:0] rdata       // Read data output
);

// Dual-port RAM module
module dual_port_RAM
#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input  wire            wclk,       // Write clock signal
    input  wire            wenc,       // Write enable signal
    input  wire [$clog2(DEPTH)-1:0] waddr,  // Write address
    input  wire [WIDTH-1:0] wdata,     // Write data input
    input  wire            rclk,       // Read clock signal
    input  wire            renc,       // Read enable signal
    input  wire [$clog2(DEPTH)-1:0] raddr,  // Read address
    output reg [WIDTH-1:0] rdata       // Read data output
);
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];  // RAM memory

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

// Instantiation of dual-port RAM module
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

// Write and read pointer logic
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;  // Binary write and read addresses
reg [$clog2(DEPTH)-1:0] wptr, rptr;           // Gray code write and read pointers
reg [$clog2(DEPTH)-1:0] wptr_syn, rptr_syn;    // Synchronized write and read pointers

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Pointer synchronization
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;  // Buffer registers for write and read pointers

always @(posedge wclk) begin
    wptr_syn <= wptr_buff;
end

always @(posedge rclk) begin
    rptr_syn <= rptr_buff;
    wptr_buff <= wptr;
    rptr_buff <= rptr;
end

// Full and empty signal generation
always @(posedge wclk) begin
    if (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
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

// Enable signals for write and read operations
reg wen, ren;  // Write and read enable signals

always @(posedge wclk) begin
    if (winc && ~wfull) begin
        wen <= 1'b1;
    end else begin
        wen <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rinc && ~rempty) begin
        ren <= 1'b1;
    end else begin
        ren <= 1'b0;
    end
end

endmodule