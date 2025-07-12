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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);

// Dual-Port RAM
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] ram [DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= ram[raddr];
    end
end

endmodule

// Binary to Gray Code Conversion
function [ADDR_WIDTH-1:0] bin_to_gray;
    input [ADDR_WIDTH-1:0] bin;
    begin
        bin_to_gray = (bin >> 1) ^ bin;
    end
endfunction

// Gray to Binary Conversion
function [ADDR_WIDTH-1:0] gray_to_bin;
    input [ADDR_WIDTH-1:0] gray;
    reg [ADDR_WIDTH-1:0] bin;
    begin
        bin = gray;
        for (int i = 1; i < ADDR_WIDTH; i++) begin
            bin = (bin ^ (bin >> i));
        end
        gray_to_bin = bin;
    end
endfunction

// Write Pointer
reg [ADDR_WIDTH-1:0] wptr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray;

// Read Pointer
reg [ADDR_WIDTH-1:0] rptr_bin;
reg [ADDR_WIDTH-1:0] rptr_gray;

// Synchronization Registers
reg [ADDR_WIDTH-1:0] wptr_sync1;
reg [ADDR_WIDTH-1:0] wptr_sync2;
reg [ADDR_WIDTH-1:0] rptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync2;

// Full and Empty Signals
reg wfull_reg;
reg rempty_reg;

// Instantiation of Dual-Port RAM
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_inst (
    .wclk(wclk),
    .wenc(winc & ~wfull),
    .waddr(wptr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc & ~rempty),
    .raddr(rptr_bin),
    .rdata(rdata)
);

// Write Pointer Increment
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc & ~wfull) begin
        wptr_bin <= (wptr_bin + 1) % DEPTH;
    end
end

// Read Pointer Increment
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc & ~rempty) begin
        rptr_bin <= (rptr_bin + 1) % DEPTH;
    end
end

// Binary to Gray Conversion for Pointers
always @(*) begin
    wptr_gray = bin_to_gray(wptr_bin);
    rptr_gray = bin_to_gray(rptr_bin);
end

// Synchronization Logic
always @(posedge wclk) begin
    wptr_sync1 <= wptr_gray;
end

always @(posedge rclk) begin
    wptr_sync2 <= wptr_sync1;
end

always @(posedge rclk) begin
    rptr_sync1 <= rptr_gray;
end

always @(posedge wclk) begin
    rptr_sync2 <= rptr_sync1;
end

// Full and Empty Signal Generation
always @(*) begin
    wfull_reg = (wptr_gray == (~rptr_gray[ADDR_WIDTH-1] + rptr_gray[ADDR_WIDTH-2:0]));
    rempty_reg = (rptr_gray == wptr_gray);
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

endmodule