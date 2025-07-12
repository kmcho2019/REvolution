module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Shared intermediate signal for power optimization
    wire and_result = a & b;
    
    // MUX-based implementation using ternary operator
    assign out_assign = b ? a : 1'b0;
    
    // Case statement implementation
    always @(*) begin
        case ({a, b})
            2'b11: out_alwaysblock = 1'b1;
            default: out_alwaysblock = 1'b0;
        endcase
    end
endmodule