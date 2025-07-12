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

reg [WIDTH-1:0] ram[DEPTH-1:0]; // Dual-port RAM

// Write and read pointers
reg [$clog2(DEPTH)-1:0] waddr; // Binary write pointer
reg [$clog2(DEPTH)-1:0] raddr; // Binary read pointer

// Write and read pointer Gray code
reg [$clog2(DEPTH)-1:0] wptr; // Gray code write pointer
reg [$clog2(DEPTH)-1:0] rptr; // Gray code read pointer

// Full and empty signals
assign wfull = (wptr == {~rptr[$clog2(DEPTH)-1], rptr[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr);

// Write and read enable signals
wire wen = winc; // Write enable signal
wire ren = rinc; // Read enable signal

// Write and read pointer increment logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr <= 0;
    end else if (wen) begin
        waddr <= waddr + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr <= 0;
    end else if (ren) begin
        raddr <= raddr + 1;
    end
end

// Write and read pointer Gray code conversion
always @(posedge wclk) begin
    wptr <= waddr ^ (waddr >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr ^ (raddr >> 1);
end

// RAM write logic
always @(posedge wclk) begin
    if (wen) begin
        ram[waddr] <= wdata;
    end
end

// RAM read logic
always @(posedge rclk) begin
    if (ren) begin
        rdata <= ram[raddr];
    end
end

endmodule