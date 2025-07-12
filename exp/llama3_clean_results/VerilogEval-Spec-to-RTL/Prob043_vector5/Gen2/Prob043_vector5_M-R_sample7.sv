module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [24:0] out;

always @(*) begin
    int i, j;
    reg [4:0] inputs;
    inputs[0] = a;
    inputs[1] = b;
    inputs[2] = c;
    inputs[3] = d;
    inputs[4] = e;
    
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
        end
    end
end

endmodule