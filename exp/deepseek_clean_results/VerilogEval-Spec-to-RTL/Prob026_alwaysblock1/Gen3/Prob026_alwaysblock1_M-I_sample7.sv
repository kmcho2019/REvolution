module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Shared AND operation
    wire and_result = a & b;
    
    // Output implementations
    assign out_assign = and_result;
    
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule