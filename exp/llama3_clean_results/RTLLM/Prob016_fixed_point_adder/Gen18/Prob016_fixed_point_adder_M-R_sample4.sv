module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    // Calculate the sum of a and b
    wire signed [N-1:0] sum = a + b;

    // Directly check for overflow conditions
    assign c = (sum == {N{1'b1}}) ? -1 :
               (sum == {1'b0, {N-1{1'b1}}) ? {N{1'b1}} - 1 :
               sum;

    // Alternatively, for better readability, the above assign statement can be broken down into an always block
    // always @(*) begin
    //     if (sum == {N{1'b1}}) begin
    //         c = -1;
    //     end else if (sum == {1'b0, {N-1{1'b1}}) begin
    //         c = {N{1'b1}} - 1;
    //     end else begin
    //         c = sum;
    //     end
    // end

endmodule