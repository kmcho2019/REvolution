module TopModule (
    output zero
);

wire dummy_input;
assign dummy_input = 1'b1; // Constant HIGH for demonstration
assign zero = dummy_input & 1'b0; // AND gate with one input as LOW

endmodule