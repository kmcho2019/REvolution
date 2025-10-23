module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    reg [31:0] shifted_result;

    always @(*) begin
        // Load all inputs into upper 30 bits
        shifted_result = {a, b, c, d, e, f, 2'b00};
        // Shift right by 2 to make room for 1's in LSBs
        shifted_result = {2'b11, shifted_result[31:2]};
    end

    assign w = shifted_result[31:24];
    assign x = shifted_result[23:16];
    assign y = shifted_result[15:8];
    assign z = shifted_result[7:0];

endmodule