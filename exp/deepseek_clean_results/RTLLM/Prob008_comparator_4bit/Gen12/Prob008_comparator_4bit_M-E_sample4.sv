module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Difference calculation (thermometer encoding basis)
wire signed [4:0] diff = {1'b0, A} - {1'b0, B};

// Thermometer code generation
wire [8:0] thermo_code;
assign thermo_code[0] = (diff <= -4);
assign thermo_code[1] = (diff <= -3);
assign thermo_code[2] = (diff <= -2);
assign thermo_code[3] = (diff <= -1);
assign thermo_code[4] = (diff == 0);
assign thermo_code[5] = (diff >= 1);
assign thermo_code[6] = (diff >= 2);
assign thermo_code[7] = (diff >= 3);
assign thermo_code[8] = (diff >= 4);

// Balanced tree decoder
wire stage1_less = thermo_code[0] | thermo_code[1] | thermo_code[2] | thermo_code[3];
wire stage1_equal = thermo_code[4];
wire stage1_greater = thermo_code[5] | thermo_code[6] | thermo_code[7] | thermo_code[8];

// Final output assignment
assign A_less = stage1_less;
assign A_equal = stage1_equal;
assign A_greater = stage1_greater;

// Verification of mutual exclusivity (can be removed in production)
// synthesis translate_off
always @(*) begin
    if ((A_less + A_equal + A_greater) != 1) begin
        $display("Error: Invalid comparator output state");
        $finish;
    end
end
// synthesis translate_on

endmodule