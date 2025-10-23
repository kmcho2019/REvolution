module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Direct arithmetic approach to calculate population count
    // Utilize wires to break down the calculation for better readability
    wire [1:0] count_01;
    wire [1:0] count_12;

    // Calculate the population count for the first two bits
    assign count_01 = {1'b0, in[0]} + {1'b0, in[1]};

    // Calculate the total population count including the third bit
    assign count_12 = count_01 + {1'b0, in[2]};

    // Assign the final result to the output
    assign out = count_12;

    // Consider adding synthesis directives or attributes as needed
    // to optimize the design for the target technology

endmodule