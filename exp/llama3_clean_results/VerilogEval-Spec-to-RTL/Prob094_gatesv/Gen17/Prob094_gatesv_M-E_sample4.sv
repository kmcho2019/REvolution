module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Internal wires to hold shifted versions of the input
    wire [3:0] left_shifted_in;  // in shifted left (circular)
    wire [3:0] right_shifted_in; // in shifted right

    // Perform circular left shift (for left neighbor)
    assign left_shifted_in = {in[0], in[3:1]};

    // Perform right shift (for right neighbor)
    assign right_shifted_in = {in[2:0], in[3]};

    // Generate outputs using bitwise operations
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // out_both: Check if current bit and its left neighbor are both 1
            assign out_both[i] = (i < 3) ? (in[i] & in[i+1]) : 1'b0;

            // out_any: Check if current bit or its right neighbor is 1
            assign out_any[i] = (i == 0) ? in[i] : (in[i] | in[i-1]);

            // out_different: Check if current bit is different from its left neighbor (wrap-around)
            assign out_different[i] = (in[i] ^ left_shifted_in[i]);
        end
    endgenerate

endmodule