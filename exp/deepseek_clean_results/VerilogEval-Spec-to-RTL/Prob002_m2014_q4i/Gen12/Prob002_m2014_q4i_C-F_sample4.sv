module TopModule (
    output out
);
    parameter CONST_VAL = 1'b0;  // Configurable constant (default 0)
    assign out = CONST_VAL;
    
    // Formal property verification
    always @(*) begin
        assert (out == 1'b0) else $error("Output not constant 0");
    end
endmodule