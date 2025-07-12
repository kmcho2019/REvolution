module TopModule(
    input  [99:0] in,  // 100-bit input
    output [99:0] out  // 100-bit output
);

    // Assign each bit of out to the corresponding bit of in, in reverse order
    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            out[99 - i] = in[i];
        end
    end

endmodule