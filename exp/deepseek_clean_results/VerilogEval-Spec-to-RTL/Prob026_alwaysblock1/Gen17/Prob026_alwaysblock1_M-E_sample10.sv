module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    parameter INVERT_OUTPUTS = 0;  // Optional parameter for output inversion
    
    // Function to compute AND operation
    function bit and_op;
        input bit x, y;
        begin
            and_op = x & y;
        end
    endfunction

    // AND gate using ternary operator in assign statement
    assign out_assign = INVERT_OUTPUTS ? ~(a & b) : (a & b);

    // AND gate using case statement in always block
    reg out_always_reg;
    always @(*) begin
        case ({a, b})
            2'b11: out_always_reg = 1'b1;
            default: out_always_reg = 1'b0;
        endcase
        if (INVERT_OUTPUTS) out_always_reg = ~out_always_reg;
    end
    assign out_alwaysblock = out_always_reg;

    // Consistency check (like simple assertion)
    always @(*) begin
        if (out_assign !== out_alwaysblock) begin
            $display("Warning: Output mismatch at time %t", $time);
        end
    end
endmodule