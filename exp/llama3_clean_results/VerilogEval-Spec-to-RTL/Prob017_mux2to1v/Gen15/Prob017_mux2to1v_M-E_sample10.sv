// Novel architectural idea: Tree-based 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Divide the 100-bit input into smaller chunks (e.g., 10-bit chunks).
// Use a hierarchical selection process to minimize the number of multiplexers required.

// Level 1: Select between 'a' and 'b' for each 10-bit chunk.
wire [9:0] level1_out [9:0];
genvar i;
for (i = 0; i < 10; i++) begin
    assign level1_out[i] = sel ? b[i*10 +: 10] : a[i*10 +: 10];
end

// Level 2: Select between the outputs of Level 1 for each 20-bit chunk.
wire [19:0] level2_out [4:0];
for (i = 0; i < 5; i++) begin
    assign level2_out[i] = sel ? {level1_out[i*2 + 1], level1_out[i*2]} : {level1_out[i*2], level1_out[i*2 + 1]};
end

// Level 3: Select between the outputs of Level 2 for each 40-bit chunk.
wire [39:0] level3_out [1:0];
for (i = 0; i < 2; i++) begin
    assign level3_out[i] = sel ? {level2_out[i*2 + 1], level2_out[i*2]} : {level2_out[i*2], level2_out[i*2 + 1]};
end

// Level 4: Select between the outputs of Level 3 for the final 100-bit output.
assign out = sel ? {level3_out[1], level3_out[0]} : {level3_out[0], level3_out[1]};

endmodule