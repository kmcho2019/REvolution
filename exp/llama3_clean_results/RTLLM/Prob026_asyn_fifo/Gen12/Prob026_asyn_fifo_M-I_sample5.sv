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
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

// Initialize variables
initial begin
    waddr_bin = 0;
    raddr_bin = 0;
    wptr = 0;
    rptr = 0;
    wfull = 0;
    rempty = 1;
    rdata = 0;
end

// Optimized Gray code conversion and pointer update logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= (waddr_bin + 1) % DEPTH;
        wptr <= {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1:1] ^ waddr_bin[ADDR_WIDTH-2:0]};
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= (raddr_bin + 1) % DEPTH;
        rptr <= {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1:1] ^ raddr_bin[ADDR_WIDTH-2:0]};
    end
end

// Improved full and empty signal generation logic
always @(posedge wclk) begin
    if (~wrstn) begin
        wfull <= 0;
    end else if (wptr[ADDR_WIDTH-1] != rptr[ADDR_WIDTH-1] && wptr[ADDR_WIDTH-2:0] == rptr[ADDR_WIDTH-2:0]) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty <= 1;
    end else if (rptr == wptr) begin
        rempty <= 1;
    end else if (rptr[ADDR_WIDTH-1] == wptr[ADDR_WIDTH-1] && rptr[ADDR_WIDTH-2:0] == (wptr[ADDR_WIDTH-2:0] + 1) % (2 ** (ADDR_WIDTH - 1))) begin
        rempty <= 0;
    end else begin
        rempty <= 0;
    end
end

// Clock gating
reg wclk_gated;
reg rclk_gated;

always @(posedge wclk) begin
    if (~wrstn) begin
        wclk_gated <= 0;
    end else if (winc) begin
        wclk_gated <= 1;
    end else begin
        wclk_gated <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rclk_gated <= 0;
    end else if (rinc) begin
        rclk_gated <= 1;
    end else begin
        rclk_gated <= 0;
    end
end

// Efficient pointer management algorithm
reg [ADDR_WIDTH-1:0] wptr_ring;
reg [ADDR_WIDTH-1:0] rptr_ring;

always @(posedge wclk_gated) begin
    if (~wrstn) begin
        wptr_ring <= 0;
    end else if (winc) begin
        wptr_ring <= (wptr_ring + 1) % DEPTH;
    end
end

always @(posedge rclk_gated) begin
    if (~rrstn) begin
        rptr_ring <= 0;
    end else if (rinc) begin
        rptr_ring <= (rptr_ring + 1) % DEPTH;
    end
end

// Asynchronous write and read controllers
always @(posedge wclk_gated) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        ram[wptr_ring] <= wdata;
    end
end

always @(posedge rclk_gated) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= ram[rptr_ring];
    end
end

endmodule