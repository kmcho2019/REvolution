module TopModule(
    input  in,
    output out
);

// Using a lookup table (LUT) approach for a NOT gate
reg [1:0] lut = 2'b10; // LUT with output for input 0 as 1 and input 1 as 0
always @(*) begin
    case (in)
        1'b0: out = lut[1];
        1'b1: out = lut[0];
    endcase
end

endmodule