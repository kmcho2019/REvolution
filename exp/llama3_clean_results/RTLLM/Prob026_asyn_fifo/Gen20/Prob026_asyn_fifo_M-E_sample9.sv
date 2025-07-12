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

// Write FIFO
reg [WIDTH-1:0] wram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] waddr;
reg [ADDR_WIDTH-1:0] wcnt;

// Read FIFO
reg [WIDTH-1:0] rram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] raddr;
reg [ADDR_WIDTH-1:0] rcnt;

// Synchronization module
reg [WIDTH-1:0] sync_data;
reg sync_valid;
reg sync_ready;

// Token-based flow control
reg token_valid;
reg token_ready;

// Write FIFO controller
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr <= 0;
        wcnt <= 0;
        wfull <= 0;
    end else if (winc && ~wfull) begin
        wram[waddr] <= wdata;
        waddr <= (waddr + 1) % DEPTH;
        wcnt <= wcnt + 1;
        if (wcnt == DEPTH - 1) begin
            wfull <= 1;
        end
    end
end

// Read FIFO controller
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr <= 0;
        rcnt <= 0;
        rempty <= 1;
        rdata <= 0;
    end else if (rinc && ~rempty) begin
        rdata <= rram[raddr];
        raddr <= (raddr + 1) % DEPTH;
        rcnt <= rcnt - 1;
        if (rcnt == 0) begin
            rempty <= 1;
        end
    end
end

// Synchronization module
always @(posedge wclk) begin
    if (winc && ~wfull) begin
        sync_data <= wdata;
        sync_valid <= 1;
    end else begin
        sync_valid <= 0;
    end
end

always @(posedge rclk) begin
    if (sync_valid && sync_ready) begin
        rram[raddr] <= sync_data;
        raddr <= (raddr + 1) % DEPTH;
        rcnt <= rcnt + 1;
        if (rcnt == DEPTH - 1) begin
            rempty <= 0;
        end
        sync_ready <= 0;
    end else begin
        sync_ready <= 1;
    end
end

// Token-based flow control
always @(posedge wclk) begin
    if (winc && ~wfull) begin
        token_valid <= 1;
    end else begin
        token_valid <= 0;
    end
end

always @(posedge rclk) begin
    if (token_valid && token_ready) begin
        token_ready <= 0;
    end else begin
        token_ready <= 1;
    end
end

endmodule