module TopModule(
    input  [7:0] in,
    output [7:0] out
);

always_comb begin
    for (int i = 0; i < 8; i++) begin
        out[i] = in[7 - i];
    end
end

endmodule