module TopModule(input in, output out);
    // Implement as a 1-input LUT (though functionally identical to a wire)
    reg lut_out;
    always @(*) begin
        case(in)
            1'b0: lut_out = 1'b0;
            1'b1: lut_out = 1'b1;
        endcase
    end
    assign out = lut_out;
endmodule