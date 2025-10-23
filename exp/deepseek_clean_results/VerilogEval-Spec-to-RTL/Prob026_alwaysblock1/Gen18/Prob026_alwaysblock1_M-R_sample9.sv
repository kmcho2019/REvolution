module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct assign statement implementation
    assign out_assign = a & b;
    
    // Combinational always block implementation
    // Note: No intermediate register needed for combinational logic
    wire always_result;
    assign out_alwaysblock = always_result;
    
    always @(*) begin
        always_result = a & b;
    end
endmodule