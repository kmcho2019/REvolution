module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [4:0] in_vector;
reg [24:0] out_vector;

always @(*) begin
    in_vector = {a, b, c, d, e};
    out_vector = 25'd0;
    
    // Compare each input signal with all five input signals
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            if (in_vector[i] == in_vector[j]) begin
                out_vector[i*5 + j] = 1'b1;
            end else begin
                out_vector[i*5 + j] = 1'b0;
            end
        end
    end
    
    out = out_vector;
end

endmodule