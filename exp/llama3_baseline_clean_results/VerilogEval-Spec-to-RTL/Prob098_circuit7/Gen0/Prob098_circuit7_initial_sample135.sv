module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialize q to 1, based on the observation that it remains 1 until 'a' becomes 1 at a rising edge of the clock
initial q = 1;

// At every positive edge of the clock, check the value of 'a'
always @(posedge clk) begin
    if (a == 1'b1) begin
        // If 'a' is 1, set 'q' to 0
        q <= 1'b0;
    end else begin
        // If 'a' is 0, keep 'q' in its current state
        // No need to explicitly assign q in this case because 'q' is already in the desired state
    end
end

endmodule