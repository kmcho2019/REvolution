module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// Local reset signal for isolation
wire local_reset;

// Clock gating control (enable when input changes)
reg [7:0] d_prev;
wire clock_enable = (d != d_prev);

// Clock gating cell
reg gated_clk;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gated_clk <= 1'b0;
    end else begin
        gated_clk <= clock_enable;
    end
end

// Reset synchronizer to prevent glitches
reg sync_reset;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        sync_reset <= 1'b1;
    end else begin
        sync_reset <= 1'b0;
    end
end

assign local_reset = areset | sync_reset;

// Main register with gated clock and isolated reset
always @(posedge clk or posedge local_reset) begin
    if (local_reset) begin
        q <= 8'b0;
        d_prev <= 8'b0;
    end else if (clock_enable) begin
        q <= d;
        d_prev <= d;
    end
end

endmodule