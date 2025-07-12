module TopModule(
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

// Define the input signals as an array for easier iteration
wire [4:0] inputs = {a, b, c, d, e};

// Initialize the output vector
reg [24:0] out_reg;

// Compute all pairwise comparisons
always @(*) begin
    out_reg = 25'd0;
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            out_reg[(i * 5) + j] = ~(inputs[i] ^ inputs[j]);
        end
    end
    out = out_reg;
end

endmodule