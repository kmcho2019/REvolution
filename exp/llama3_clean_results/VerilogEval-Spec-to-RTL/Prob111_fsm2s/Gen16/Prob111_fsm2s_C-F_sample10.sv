module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg counter; // Single-bit counter for OFF (0) and ON (1) states

// Output logic
assign out = counter; // Directly assign counter value to output

// Counter with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        counter <= 1'b0; // Reset to OFF state
    end else begin
        counter <= (counter &&!k) || (!counter && j); // Transition based on inputs
    end
end

endmodule