// Novel architectural solution using a multiplexer and logical operators.
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Internal wires for the AND and OR operations.
wire and_result;
wire or_result;

// Perform the AND operation for the case when 'a' is 0.
assign and_result = b & c;

// Perform the OR operation for the case when 'a' is 1.
assign or_result = b | c;

// Use a multiplexer to select between the AND and OR results based on 'a'.
assign out = a? or_result : and_result;

endmodule