module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // Explicitly define state as a reg for clarity

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset to state B
        state <= 1'b1;
    end else begin
        // Simplify state transition logic using ternary operator
        state <= (state == 1'b0) ? (~in) : (in ? 1'b1 : 1'b0);
    end
end

// Directly assign output based on the state, characteristic of a Moore machine
assign out = state;

endmodule