module TopModule(
    input  [99:0] in,  // 100-bit input
    output [99:0] out  // 100-bit output
);

    // Reverse the bit ordering of the input
    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            out[i] = in[99 - i];  // Assign each bit of out to the corresponding reversed bit of in
        end
    end

endmodule