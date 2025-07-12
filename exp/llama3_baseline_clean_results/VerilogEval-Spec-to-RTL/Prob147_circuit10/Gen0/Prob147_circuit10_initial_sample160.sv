module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    // Next state logic
    if (a == 1'b0 && b == 1'b1) begin
        state <= ~state; // Toggle state when a is 0 and b is 1
    end else if (a == 1'b1 && b == 1'b1) begin
        state <= 1'b0; // Reset state when a and b are 1
    end else begin
        state <= state; // Hold state for other conditions
    end
    
    // Output q logic
    if (b == 1'b1 && a == 1'b0) begin
        q <= 1'b1; // q is 1 when b is 1 and a is 0
    end else if (b == 1'b0 && a == 1'b1) begin
        q <= ~state; // q is inverse of state when b is 0 and a is 1
    end else begin
        q <= state; // q follows state for other conditions
    end
end

endmodule