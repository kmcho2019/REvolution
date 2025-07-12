module TopModule(
    input clk,
    input x,
    output z
);

reg [2:0] ff_out; // Internal signals for the D flip-flops

// Define the outputs of the gates
wire xor_out, and_out, or_out;

// Describe the behavior of the gates
assign xor_out = x ^ ff_out[0];
assign and_out = x & ~ff_out[1];
assign or_out = x | ~ff_out[2];

// Describe the behavior of the D flip-flops
always @(posedge clk) begin
    ff_out[0] <= xor_out;
    ff_out[1] <= and_out;
    ff_out[2] <= or_out;
end

// Describe the behavior of the NOR gate to generate the output z
assign z = ~(ff_out[0] | ff_out[1] | ff_out[2]);

endmodule