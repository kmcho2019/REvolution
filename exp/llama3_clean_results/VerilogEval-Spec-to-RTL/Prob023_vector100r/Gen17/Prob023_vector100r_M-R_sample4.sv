module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector (reversed input)
);

    // Direct assignment to reverse the input vector
    assign out = {<< {WIDTH{1'b0}} >> in}; // Using bit manipulation to reverse

    // Alternatively, you can use a for loop in an always block for a different structure
    // always @(*) begin
    //     for (int i = 0; i < WIDTH; i++) begin
    //         out[WIDTH - 1 - i] = in[i];
    //     end
    // end

endmodule