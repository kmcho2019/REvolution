module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // Intermediate 32-bit register built in stages
    reg [31:0] shifted_result;
    
    // Build the result by shifting and adding each input
    always @(*) begin
        shifted_result = 32'b0;
        shifted_result = (shifted_result << 5) | a;
        shifted_result = (shifted_result << 5) | b;
        shifted_result = (shifted_result << 5) | c;
        shifted_result = (shifted_result << 5) | d;
        shifted_result = (shifted_result << 5) | e;
        shifted_result = (shifted_result << 5) | f;
        shifted_result = (shifted_result << 2) | 2'b11;
    end
    
    // Assign outputs from the shifted result
    assign w = shifted_result[31:24];
    assign x = shifted_result[23:16];
    assign y = shifted_result[15:8];
    assign z = shifted_result[7:0];

endmodule