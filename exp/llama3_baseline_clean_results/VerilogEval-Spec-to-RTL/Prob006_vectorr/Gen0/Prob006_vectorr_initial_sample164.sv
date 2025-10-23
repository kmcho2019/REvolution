module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

// Alternatively, a more concise way to reverse bits without listing each bit:
// assign out = in[0] ? 8'b1 : 8'b0;
// The above does not work. Instead, we can use a loop in a generate statement, 
// or we can use a for loop in an always block.

// Here is a for loop in an always block:
always @(*) begin
    for (int i = 0; i < 8; i++) begin
        out[i] = in[7-i];
    end
end

endmodule