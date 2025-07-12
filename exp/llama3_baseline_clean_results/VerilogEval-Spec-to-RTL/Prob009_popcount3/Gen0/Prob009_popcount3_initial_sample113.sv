module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    always @(*)
    begin
        out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};
    end

endmodule