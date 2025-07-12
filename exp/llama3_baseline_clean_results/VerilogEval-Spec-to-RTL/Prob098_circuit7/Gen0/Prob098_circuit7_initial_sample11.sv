module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Initialize q to 1
);

reg prev_a; // Register to hold the previous state of a

always @(posedge clk) begin
    prev_a <= a; // Update prev_a on the positive edge of clk
    if (a == 1'b1 && prev_a == 1'b1) begin
        q <= 1'b0; // Set q to 0 if a is 1 for two consecutive clocks
    end else if (a == 1'b0) begin
        q <= 1'b1; // Set q to 1 if a is 0 at any point after being high
    end
end

endmodule