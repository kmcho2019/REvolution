module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    if (a & b)
        state <= ~state;       // Toggle state when both a and b are 1
    else if (b)
        state <= 1'b1;         // Set state when b is 1 (and a is 0)
    else if (a)
        state <= 1'b0;         // Reset state when a is 1 (and b is 0)
    else
        state <= state;        // Hold state otherwise
end

assign q = state;               // Output equals current state

initial state = 1'b0;           // Initialize state to 0

endmodule