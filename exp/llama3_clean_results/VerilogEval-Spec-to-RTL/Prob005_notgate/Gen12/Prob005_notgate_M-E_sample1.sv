module TopModule(
    input  in,
    output out
);
    reg [1:0] lut[1:0];
    initial begin
        lut[0] = 1; // output for input 0
        lut[1] = 0; // output for input 1
    end
    always @(*) begin
        out = lut[in];
    end
endmodule