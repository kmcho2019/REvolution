module TopModule (
    input in,
    output out
);
    // NOT gate implemented using a 1-bit LUT approach
    // Demonstrates alternative implementation for programmable logic
    reg out_reg;
    
    always @(*) begin
        case(in)
            1'b0: out_reg = 1'b1;
            1'b1: out_reg = 1'b0;
        endcase
    end
    
    assign out = out_reg;
endmodule