module LUT_Module(x, y, z);
    input x, y;
    output z;
    reg [1:0] inputs;
    reg output;
    
    always @(*) begin
        inputs = {x, y};
        case (inputs)
            2'b00: output = 1; // x = 0, y = 0
            2'b01: output = 0; // x = 0, y = 1
            2'b10: output = 0; // x = 1, y = 0
            2'b11: output = 1; // x = 1, y = 1
        endcase
    end
    
    assign z = output;
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire lut1_out, lut2_out, or_out, and_out;
    
    LUT_Module lut1(x, y, lut1_out);
    LUT_Module lut2(x, y, lut2_out);
    
    assign or_out = lut1_out | lut2_out;
    assign and_out = lut1_out & lut2_out;
    assign z = or_out ^ and_out; // Final output logic
endmodule