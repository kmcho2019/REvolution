// TopModule: Always drives output 'one' high.
module TopModule(
    output one
);

// Define a local parameter for the constant output value.
localparam LOGIC_HIGH = 1'b1;

// Assign the local parameter to the output 'one'.
assign one = LOGIC_HIGH;

endmodule