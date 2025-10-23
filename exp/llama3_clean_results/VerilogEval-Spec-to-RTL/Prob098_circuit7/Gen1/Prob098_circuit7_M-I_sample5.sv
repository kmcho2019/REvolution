module TopModule(
    input clk,
    input a,
    output reg q = 1 // Initialize q to 1
);

reg prev_a = 1'b0; // To keep track of previous state of a
reg q_set = 1'b0; // Flag to indicate if q has been set to 0

always @(posedge clk) begin
    if (!a) begin // If a is 0
        q <= 1'b1; // Set q to 1
        q_set <= 1'b0; // Reset the flag
    end else if (a && !prev_a && !q_set) begin // a is 1 and was previously 0 and q hasn't been set to 0
        q <= 1'b0; // Set q to 0
        q_set <= 1'b1; // Set the flag
    end
    prev_a <= a; // Update previous state of a
end

endmodule