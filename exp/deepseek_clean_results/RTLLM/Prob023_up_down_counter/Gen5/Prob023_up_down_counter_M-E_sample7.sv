module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Parallel prefix adder implementation
wire [15:0] delta = up_down ? 16'h0001 : 16'hFFFF; // +1 or -1
wire [15:0] next_count;

// Generate and propagate logic
wire [15:0] g = count & delta;
wire [15:0] p = count ^ delta;

// Carry computation
wire [15:0] carry;
assign carry[0] = 1'b0;
assign carry[1] = g[0] | (p[0] & carry[0]);
assign carry[2] = g[1] | (p[1] & carry[1]);
assign carry[3] = g[2] | (p[2] & carry[2]);
assign carry[4] = g[3] | (p[3] & carry[3]);
assign carry[5] = g[4] | (p[4] & carry[4]);
assign carry[6] = g[5] | (p[5] & carry[5]);
assign carry[7] = g[6] | (p[6] & carry[6]);
assign carry[8] = g[7] | (p[7] & carry[7]);
assign carry[9] = g[8] | (p[8] & carry[8]);
assign carry[10] = g[9] | (p[9] & carry[9]);
assign carry[11] = g[10] | (p[10] & carry[10]);
assign carry[12] = g[11] | (p[11] & carry[11]);
assign carry[13] = g[12] | (p[12] & carry[12]);
assign carry[14] = g[13] | (p[13] & carry[13]);
assign carry[15] = g[14] | (p[14] & carry[14]);

// Sum computation
assign next_count = p ^ carry;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule