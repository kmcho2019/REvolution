module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_Q;

// Combinational next state logic
assign next_Q = (j & k) ? ~Q :  // Toggle when both are 1
                (j & ~k) ? 1'b1 : // Set when J=1, K=0
                (~j & k) ? 1'b0 : // Reset when J=0, K=1
                Q;               // Hold when both are 0

// Sequential element (D flip-flop)
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule