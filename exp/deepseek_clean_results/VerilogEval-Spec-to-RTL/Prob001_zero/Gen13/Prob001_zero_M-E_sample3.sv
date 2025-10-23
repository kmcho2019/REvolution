module TopModule(output zero);
    reg lut_out;
    
    // 1-bit LUT implementation
    always @(*) begin
        case (1'b0)  // Input is hardwired to 0
            1'b0: lut_out = 1'b0;
            default: lut_out = 1'b0;
        endcase
    end
    
    assign zero = lut_out;
endmodule