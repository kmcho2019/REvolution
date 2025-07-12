module TopModule (
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Standard assign implementation
    assign out_assign = a & b;

    // Alternative always block implementation
    always @(*) begin
        reg temp;
        temp = a & b;  // Store intermediate result
        
        // Demonstrate alternative ways to express the same logic
        case ({a, b})
            2'b00: out_alwaysblock = 1'b0;
            2'b01: out_alwaysblock = 1'b0;
            2'b10: out_alwaysblock = 1'b0;
            2'b11: out_alwaysblock = 1'b1;
            default: out_alwaysblock = 1'b0;
        endcase
        
        // The case statement could be replaced with:
        // out_alwaysblock = temp;
    end

endmodule