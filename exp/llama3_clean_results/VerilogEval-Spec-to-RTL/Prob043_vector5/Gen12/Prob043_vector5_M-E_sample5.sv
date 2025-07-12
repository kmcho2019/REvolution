module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Define the input signals as a wire array for easier manipulation
wire [4:0] signals = {a, b, c, d, e};

// Initialize the output vector
wire [24:0] out_vector;

// Generate the output vector using a grid of comparison logic cells
genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            // Use a single logic cell to compare two input signals
            assign out_vector[i*5 + j] = ~(signals[i] ^ signals[j]);
        end
    end
endgenerate

// Assign the generated output vector to the output port
assign out = out_vector;

endmodule