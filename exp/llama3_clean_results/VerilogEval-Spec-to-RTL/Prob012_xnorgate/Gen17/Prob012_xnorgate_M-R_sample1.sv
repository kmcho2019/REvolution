// Module TopModule implements an XNOR gate using a combinational logic block
module TopModule(
    input a,  // Input signal a
    input b,  // Input signal b
    output reg out // Output signal out
);

// Use an always block to implement the combinational logic
always @(*) begin
    // Check if both inputs are the same
    if (a == b) begin
        // If both are the same, output 1
        out = 1'b1;
    end else begin
        // If inputs are different, output 0
        out = 1'b0;
    end
end

endmodule