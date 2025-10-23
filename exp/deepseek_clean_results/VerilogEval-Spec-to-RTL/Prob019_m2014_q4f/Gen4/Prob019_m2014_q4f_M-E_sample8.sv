module TopModule (
    input in1,
    input in2,
    output out
);

    // 2-input LUT implementation
    reg [0:3] lut = 4'b0010; // Truth table for A AND (NOT B)
    
    always @(*) begin
        case ({in1, in2})
            2'b00: out = lut[0];
            2'b01: out = lut[1];
            2'b10: out = lut[2];
            2'b11: out = lut[3];
            default: out = 1'b0;
        endcase
    end

endmodule