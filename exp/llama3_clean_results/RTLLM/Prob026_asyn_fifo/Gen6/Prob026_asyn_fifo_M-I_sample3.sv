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

// Dual-Port RAM (DPRAM) submodule
reg [WIDTH-1:0] dpram [DEPTH-1:0];

// Write and read pointers in binary
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

// Write and read pointers in Gray code
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

// Handshake protocol for synchronization
reg wptr_sync_valid;
reg rptr_sync_valid;
reg [ADDR_WIDTH-1:0] wptr_sync;
reg [ADDR_WIDTH-1:0] rptr_sync;

// Counter for full and empty signals
reg [ADDR_WIDTH:0] cnt;

// Function to convert binary to Gray code
function [ADDR_WIDTH-1:0] bin_to_gray;
input [ADDR_WIDTH-1:0] bin;
begin
    bin_to_gray = bin ^ (bin >> 1);
end
endfunction

// Gray code conversion
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= bin_to_gray(waddr_bin);
    end else begin
        wptr <= bin_to_gray(waddr_bin);
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= bin_to_gray(raddr_bin);
    end else begin
        rptr <= bin_to_gray(raddr_bin);
    end
end

// Handshake protocol for synchronization
always @(posedge rclk) begin
    wptr_sync_valid <= 1'b1;
    wptr_sync <= wptr;
end

always @(posedge wclk) begin
    rptr_sync_valid <= 1'b1;
    rptr_sync <= rptr;
end

// Counter for full and empty signals
always @(posedge wclk) begin
    if (~wrstn) begin
        cnt <= 0;
    end else if (winc && ~wfull) begin
        cnt <= cnt + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        cnt <= 0;
    end else if (rinc && ~rempty) begin
        cnt <= cnt - 1;
    end
end

// Full and empty signals
assign wfull = (cnt == DEPTH);
assign rempty = (cnt == 0);

// Write operation
always @(posedge wclk) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        dpram[waddr_bin] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= dpram[raddr_bin];
    end
end

endmodule