module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Simplified delta computation - only affects LSB for +1/-1
wire delta = up_down ? 1'b1 : 1'b0;
wire carry_in = ~up_down; // Borrow for decrement

// Optimized carry computation for first 4 bits only
wire [3:0] g = count[3:0] & {4{delta}};
wire [3:0] p = count[3:0] ^ {4{delta}};
wire [4:0] carry;

assign carry[0] = carry_in;
assign carry[1] = g[0] | (p[0] & carry[0]);
assign carry[2] = g[1] | (p[1] & carry[1]);
assign carry[3] = g[2] | (p[2] & carry[2]);
assign carry[4] = g[3] | (p[3] & carry[3]);

// Clock gating when upper bits don't need to change
wire count_enable = ~reset & (|count[15:4] | |carry[4] | ~(&count[3:0]));

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (count_enable) begin
        // Simple adder for lower 4 bits with carry lookahead
        count[3:0] <= p ^ carry[3:0];
        
        // Standard increment/decrement for upper bits when needed
        if (carry[4]) begin
            if (up_down)
                count[15:4] <= count[15:4] + 1'b1;
            else
                count[15:4] <= count[15:4] - 1'b1;
        end
    end
end

endmodule