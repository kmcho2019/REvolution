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
reg [24:0] out_vector;

// Generate the output vector using bitwise operations
always @(*) begin
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            // Use bitwise XOR and inverting operations to compare two input signals
            out_vector[i*5 + j] = ~(signals[i] ^ signals[j]);
        end
    end
end

// Assign the generated output vector to the output port
assign out = out_vector;

endmodule