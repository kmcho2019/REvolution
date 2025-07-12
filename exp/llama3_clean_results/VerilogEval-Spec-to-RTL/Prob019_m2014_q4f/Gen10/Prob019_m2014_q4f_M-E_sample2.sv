module TopModule(
    input  in1,
    input  in2,
    output out
);
    reg [1:0] lut [3:0];
    integer i;

    initial begin
        // Initialize the LUT with the desired output values
        lut[0] = 4'b0000; // in1 = 0, in2 = 0
        lut[1] = 4'b0000; // in1 = 0, in2 = 1
        lut[2] = 4'b0000; // in1 = 1, in2 = 0
        lut[3] = 4'b0000; // in1 = 1, in2 = 1
        lut[2] = 4'b0001; // Correct the LUT value for in1 = 1, in2 = 0
    end

    always @(*) begin
        // Use the LUT to determine the output value
        case ({in1, in2})
            2'b00: out = lut[0][0];
            2'b01: out = lut[1][0];
            2'b10: out = lut[2][0];
            2'b11: out = lut[3][0];
        endcase
    end
endmodule