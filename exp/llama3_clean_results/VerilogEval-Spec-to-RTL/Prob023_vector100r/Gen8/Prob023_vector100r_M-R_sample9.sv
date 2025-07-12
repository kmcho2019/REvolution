module TopModule(
    input [99:0] in,
    output [99:0] out
);

generate
    for (genvar i = 0; i < 100; i++) begin
        assign out[i] = in[99 - i];
    end
endgenerate

endmodule