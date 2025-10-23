module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Shared AND operation
    wire and_result = a & b;
    
    // Continuous assignment
    assign out_assign = and_result;
    
    // Combinational always block
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule