module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Shared AND operation
    wire and_result = a & b;
    
    // Assign implementation
    assign out_assign = and_result;
    
    // Always block implementation
    always @(*) begin
        out_alwaysblock = and_result;
    end
endmodule