module TopModule(
    input [99:0] in,  // Input is 100 bits
    output [99:0] out  // Output is 100 bits
);

// Assign the bits of out in reverse order of in
always @(*) begin
    for (int i = 0; i < 100; i++) begin
        out[i] = in[99 - i];
    end
end

endmodule