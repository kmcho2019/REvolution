module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    /* Truth Table Documentation:
    case ({a, b})
        2'b00: {sum, cout} = 2'b00;
        2'b01: {sum, cout} = 2'b10;
        2'b10: {sum, cout} = 2'b10;
        2'b11: {sum, cout} = 2'b01;
    endcase
    */
    
    // Optimal gate-level implementation
    assign sum = a ^ b;   // XOR operation
    assign cout = a & b;  // AND operation
endmodule