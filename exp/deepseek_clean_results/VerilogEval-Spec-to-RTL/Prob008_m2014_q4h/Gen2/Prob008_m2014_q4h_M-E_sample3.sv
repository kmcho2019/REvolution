module TopModule (
    input in,
    output out
);
    // Using a 1-bit LUT implementation
    reg lut [0:0];
    
    always @(*) begin
        lut[0] = in;
    end
    
    assign out = lut[0];
endmodule