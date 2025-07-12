module TopModule(
    input clk,
    input a,
    output reg q = 1 // Initialize q to 1
);

reg prev_a = 1'b0; // To keep track of previous state of a

always @(posedge clk) begin
    if (a && !prev_a) // a is 1 and was previously 0
        q <= 1'b0; // Set q to 0
    prev_a <= a; // Update previous state of a
end

endmodule