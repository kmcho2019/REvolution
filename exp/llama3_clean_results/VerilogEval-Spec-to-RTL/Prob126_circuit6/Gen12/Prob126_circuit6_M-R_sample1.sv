module TopModule(
    input [2:0] a,
    output [15:0] q
);

reg [15:0] q_reg;

// Define an array of constants to store the output values
reg [15:0] output_values [7:0];

// Initialize the output values
initial begin
    output_values[0] = 16'h1232;
    output_values[1] = 16'haee0;
    output_values[2] = 16'h27d4;
    output_values[3] = 16'h5a0e;
    output_values[4] = 16'h2066;
    output_values[5] = 16'h64ce;
    output_values[6] = 16'hc526;
    output_values[7] = 16'h2f19;
end

// Use an always block to assign the output q
always @(*) begin
    case (a)
        3'b000: q_reg = output_values[0];
        3'b001: q_reg = output_values[1];
        3'b010: q_reg = output_values[2];
        3'b011: q_reg = output_values[3];
        3'b100: q_reg = output_values[4];
        3'b101: q_reg = output_values[5];
        3'b110: q_reg = output_values[6];
        3'b111: q_reg = output_values[7];
        default: q_reg = 16'h0000; // Default value
    endcase
end

// Assign the output q
assign q = q_reg;

endmodule