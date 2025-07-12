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
reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;

// Reset logic
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_gray <= 0;
        wfull <= 0;
    end else if (winc) begin
        waddr_bin <= (waddr_bin + 1) % DEPTH;
        wptr_gray <= {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1:1] ^ waddr_bin[ADDR_WIDTH-2:0]};
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_gray <= 0;
        rempty <= 1;
    end else if (rinc) begin
        raddr_bin <= (raddr_bin + 1) % DEPTH;
        rptr_gray <= {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1:1] ^ raddr_bin[ADDR_WIDTH-2:0]};
    end
end

// Full and empty detection
assign wfull = (wptr_gray[ADDR_WIDTH-1]!= rptr_gray[ADDR_WIDTH-1] && wptr_gray[ADDR_WIDTH-2:0] == rptr_gray[ADDR_WIDTH-2:0]);
assign rempty = (rptr_gray == wptr_gray);

// Write logic
always @(posedge wclk) begin
    if (winc && ~wfull) begin
        ram[waddr_bin] <= wdata;
    end
end

// Read logic
always @(posedge rclk) begin
    if (rinc && ~rempty) begin
        rdata <= ram[raddr_bin];
    end
end

endmodule