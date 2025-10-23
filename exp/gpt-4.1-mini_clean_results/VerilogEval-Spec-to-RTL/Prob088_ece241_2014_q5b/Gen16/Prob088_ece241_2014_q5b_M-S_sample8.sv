module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg stateB; // 1-bit one-hot: 0 = A, 1 = B

// Next state logic
wire next_stateB = stateB ? 1'b1 : x;

// Output logic
assign z = stateB ? ~x : x;

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        stateB <= 1'b0; // reset to A
    else
        stateB <= next_stateB;
end

endmodule