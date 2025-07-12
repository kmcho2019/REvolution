module TopModule(
    input [31:0] in,
    output [31:0] out
);

// Use a for loop to iterate over the bytes of the input vector
// and assign them to the reversed positions in the output vector.
integer i;
always @(*) begin
    for (i = 0; i < 4; i++) begin
        out[(3-i)*8 +: 8] = in[i*8 +: 8];
    end
end

endmodule