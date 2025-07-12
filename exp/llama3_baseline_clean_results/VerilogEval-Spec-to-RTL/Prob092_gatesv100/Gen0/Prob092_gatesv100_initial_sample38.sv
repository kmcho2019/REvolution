module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

always @(*) begin
    for (int i = 0; i < 100; i++) begin
        // out_both: Check if current bit and its neighbour to the left are both '1'
        out_both[i] = (i == 99)? 0 : (in[i] && in[i+1])? 1'b1 : 1'b0;

        // out_any: Check if either current bit or its neighbour to the right is '1'
        out_any[i] = (i == 0)? 0 : (in[i] || in[i-1])? 1'b1 : 1'b0;

        // out_different: Check if current bit is different from its neighbour to the left
        out_different[i] = (in[i]!= (i == 99)? in[0] : in[i+1])? 1'b1 : 1'b0;
    end
end

endmodule