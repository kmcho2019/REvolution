module TopModule (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

// Internal memory for code-to-digit mapping
reg [4:0] code_map [0:255]; // [4] is valid bit, [3:0] is digit

integer i;
initial begin
    // Initialize all entries to invalid (0)
    for (i = 0; i < 256; i = i + 1) begin
        code_map[i] = 5'b0_0000;
    end
    
    // Set valid codes
    code_map[8'h45] = 5'b1_0000; // 0
    code_map[8'h16] = 5'b1_0001; // 1
    code_map[8'h1e] = 5'b1_0010; // 2
    code_map[8'h26] = 5'b1_0011; // 3
    code_map[8'h25] = 5'b1_0100; // 4
    code_map[8'h2e] = 5'b1_0101; // 5
    code_map[8'h36] = 5'b1_0110; // 6
    code_map[8'h3d] = 5'b1_0111; // 7
    code_map[8'h3e] = 5'b1_1000; // 8
    code_map[8'h46] = 5'b1_1001; // 9
end

// Output assignment
always @(*) begin
    {valid, out} = code_map[code];
end

endmodule