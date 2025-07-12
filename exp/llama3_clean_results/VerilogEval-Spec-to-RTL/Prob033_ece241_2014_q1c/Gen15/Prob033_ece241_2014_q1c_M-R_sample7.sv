// Define the TopModule with integrated adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Internal wires for the sum
    wire [8:0] sum_extended;

    // Calculate the sum using a simplified adder
    assign sum_extended = {1'b0, a} + {1'b0, b};

    // Assign the sum to the output
    assign s = sum_extended[7:0];

    // Calculate the overflow
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule