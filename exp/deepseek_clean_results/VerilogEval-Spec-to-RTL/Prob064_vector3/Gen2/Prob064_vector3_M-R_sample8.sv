module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // First concatenate all inputs (30 bits)
    wire [29:0] inputs_concat = {a, b, c, d, e, f};
    
    // Then create final 32-bit value by adding two '1' bits at LSB
    wire [31:0] final_value = {inputs_concat, 2'b11};

    // Assign outputs by slicing the final value
    assign w = final_value[31:24];
    assign x = final_value[23:16];
    assign y = final_value[15:8];
    assign z = final_value[7:0];

endmodule