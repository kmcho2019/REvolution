module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Use a for loop to assign the bytes of the input vector to the output vector in reverse order
    always @(*) begin
        for (int i = 0; i < 4; i++) begin
            out[(i * 8) +: 8] = in[(3 - i) * 8 +: 8];
        end
    end

endmodule