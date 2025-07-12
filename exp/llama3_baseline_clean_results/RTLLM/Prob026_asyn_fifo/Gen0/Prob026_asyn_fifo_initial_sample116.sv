module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wire            wclk,      // Write clock signal
    input  wire            rclk,      // Read clock signal
    input  wire            wrstn,     // Write reset signal
    input  wire            rrstn,     // Read reset signal
    input  wire            winc,      // Write increment signal
    input  wire            rinc,      // Read increment signal
    input  wire    [WIDTH-1:0] wdata,  // Write data input
    output wire            wfull,     // Write full signal
    output wire            rempty,    // Read empty signal
    output wire    [WIDTH-1:0] rdata   // Read data output
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input  wire            wclk,      // Write clock signal
    input  wire            wenc,      // Write enable signal
    input  wire    [$clog2(DEPTH)-1:0] waddr,  // Write address
    input  wire    [WIDTH-1:0] wdata,  // Write data input
    input  wire            rclk,      // Read clock signal
    input  wire            renc,      // Read enable signal
    input  wire    [$clog2(DEPTH)-1:0] raddr,  // Read address
    output wire    [WIDTH-1:0] rdata   // Read data output
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

// Instantiation of dual-port RAM module
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

// Write and read pointer registers
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;

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

// Gray code conversion for write and read pointers
reg [$clog2(DEPTH)-1:0] wptr, rptr;

always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_sync1, rptr_sync2;

always @(posedge wclk) begin
    rptr_sync1 <= rptr;
    rptr_sync2 <= rptr_sync1;
    rptr_syn <= rptr_sync2;
end

// Write and read enable signals
reg wen, ren;

always @(posedge wclk) begin
    wen <= winc;
end

always @(posedge rclk) begin
    ren <= rinc;
end

// Full and empty detection logic
always @(posedge wclk) begin
    if (wptr == ({~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]})) begin
        wfull <= 1'b1;
    end else begin
        wfull <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr == wptr) begin
        rempty <= 1'b1;
    end else begin
        rempty <= 1'b0;
    end
end

endmodule