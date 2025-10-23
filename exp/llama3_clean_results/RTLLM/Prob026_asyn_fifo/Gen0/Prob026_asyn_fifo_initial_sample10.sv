module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)
(
    input  wire wclk,  // Write clock signal
    input  wire rclk,  // Read clock signal
    input  wire wrstn, // Write reset signal (0 for reset, 1 for reset inactive)
    input  wire rrstn, // Read reset signal (0 for reset, 1 for reset inactive)
    input  wire winc,  // Write increment signal
    input  wire rinc,  // Read increment signal
    input  wire [WIDTH-1:0] wdata, // Write data input
    output wire wfull, // Write full signal
    output wire rempty, // Read empty signal
    output wire [WIDTH-1:0] rdata // Read data output
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)
(
    input  wire wclk,  // Write clock signal
    input  wire wenc,  // Write enable signal
    input  wire [$clog2(DEPTH)-1:0] waddr, // Write address
    input  wire [WIDTH-1:0] wdata, // Write data
    input  wire rclk,  // Read clock signal
    input  wire renc,  // Read enable signal
    input  wire [$clog2(DEPTH)-1:0] raddr, // Read address
    output reg  [WIDTH-1:0] rdata // Read data
);

    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0]; // RAM memory

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
) ram (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr_bin),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr_bin),
   .rdata(rdata)
);

// Write and read pointers
reg [$clog2(DEPTH)-1:0] waddr_bin; // Binary write pointer
reg [$clog2(DEPTH)-1:0] raddr_bin; // Binary read pointer

// Write and read pointer Gray code
reg [$clog2(DEPTH)-1:0] wptr; // Gray code write pointer
reg [$clog2(DEPTH)-1:0] rptr; // Gray code read pointer

// Write and read pointer buffers
reg [$clog2(DEPTH)-1:0] wptr_buff; // Write pointer buffer
reg [$clog2(DEPTH)-1:0] rptr_buff; // Read pointer buffer

// Full and empty signals
assign wfull = (wptr == {~rptr[$clog2(DEPTH)-1], rptr[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr);

// Write and read enable signals
reg wen; // Write enable signal
reg ren; // Read enable signal

// Write and read pointer increment logic
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

// Write and read pointer Gray code conversion
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Write and read pointer buffer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr;
    end
end

// Write and read enable logic
always @(posedge wclk) begin
    if (~wrstn) begin
        wen <= 0;
    end else if (winc) begin
        wen <= 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        ren <= 0;
    end else if (rinc) begin
        ren <= 1;
    end
end

endmodule