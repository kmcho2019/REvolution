module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg state_A, state_B;

// Output logic: z = x if in A, else ~x
assign z = state_A ? x : ~x;

// State update logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= state_A & ~x;
        state_B <= state_A & x | state_B;
    end
end

endmodule