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
wire [24:0] out_vec;

// Use a loop to generate the output vector
genvar i;
generate
    for (i = 0; i < 25; i++) begin
        // Calculate the indices of the signals to compare
        wire [1:0] idx1 = (i / 5);
        wire [1:0] idx2 = (i % 5);
        
        // Compare the signals using XOR and negation
        assign out_vec[i] = ~(signals[idx1] ^ signals[idx2]);
    end
endgenerate

// Assign the output vector to the output port
assign out = out_vec;

endmodule