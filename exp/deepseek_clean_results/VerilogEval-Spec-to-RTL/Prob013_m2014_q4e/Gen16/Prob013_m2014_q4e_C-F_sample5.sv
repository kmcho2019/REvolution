module TopModule (
    input in1,
    input in2,
    output out
);
    // Optimal implementation using NOR primitive (best PPA)
    nor(out, in1, in2);
    
    /* Alternative implementation using case statement (for reference)
    reg out_reg;
    always @(*) begin
        case ({in1, in2})
            2'b00: out_reg = 1'b1;
            2'b01: out_reg = 1'b0;
            2'b10: out_reg = 1'b0;
            2'b11: out_reg = 1'b0;
        endcase
    end
    assign out = out_reg;
    */
endmodule