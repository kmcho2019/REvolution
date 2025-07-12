module TopModule(
    input [99:0] in,  // input is a 100-bit vector
    output [99:0] out // output is a 100-bit vector
);

    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            out[i] = in[99 - i]; // Assign bits in reverse order
        end
    end

endmodule