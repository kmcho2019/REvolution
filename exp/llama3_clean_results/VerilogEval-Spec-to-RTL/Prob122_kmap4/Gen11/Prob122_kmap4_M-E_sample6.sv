module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Define the output values for each 'cd' combination
    wire [3:0] output_values = 4'b1010;  // For 'cd' = 00, 01, 11, 10 respectively
    
    // Create a 2-bit selector based on 'ab'
    wire [1:0] selector = {a, b};
    
    // Use the selector to choose the output from the output values
    assign out = (selector == 2'b00) ? output_values[0] :
                 (selector == 2'b01) ? output_values[1] :
                 (selector == 2'b11) ? output_values[2] :
                 (selector == 2'b10) ? output_values[3] : 1'b0;

    // Adjust the output based on the 'cd' inputs
    assign out = (c == 0 && d == 0) ? output_values[0] :
                 (c == 0 && d == 1) ? output_values[1] :
                 (c == 1 && d == 1) ? output_values[2] :
                 (c == 1 && d == 0) ? output_values[3] : 1'b0;

    // Final output
    assign out = (c == 0 && d == 0 && (a ^ b)) ? 1'b1 :
                 (c == 0 && d == 1 && ~(a ^ b)) ? 1'b1 :
                 (c == 1 && d == 1 && (a ^ b)) ? 1'b1 :
                 (c == 1 && d == 0 && ~(a ^ b)) ? 1'b1 : 1'b0;

endmodule