module TopModule (
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] sum01;  // Sum of in[0] and in[1]
    wire [1:0] total;  // Final sum including in[2]

    // First add in[0] and in[1]
    assign sum01 = {1'b0, in[0]} + {1'b0, in[1]};

    // Then add in[2] to the partial sum
    assign total = sum01 + {1'b0, in[2]};

    // Output the 2-bit result
    assign out = total;

endmodule