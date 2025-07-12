module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Declare an array of inputs for clarity
    wire [4:0] inputs_array [5:0];
    assign inputs_array[0] = a;
    assign inputs_array[1] = b;
    assign inputs_array[2] = c;
    assign inputs_array[3] = d;
    assign inputs_array[4] = e;
    assign inputs_array[5] = f;

    // Flatten inputs into a 30-bit vector by concatenating the array elements in order
    wire [29:0] concat_inputs = {inputs_array[0], inputs_array[1], inputs_array[2], inputs_array[3], inputs_array[4], inputs_array[5]};

    // Construct the 32-bit output vector: concatenated inputs followed by 2 LSB '1' bits
    wire [31:0] final_vector = {concat_inputs, 2'b11};

    // Assign outputs by slicing final_vector into four 8-bit segments
    assign w = final_vector[31:24];
    assign x = final_vector[23:16];
    assign y = final_vector[15:8];
    assign z = final_vector[7:0];

endmodule