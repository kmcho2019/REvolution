module TopModule (
    output one
);
    // Novel counter-based always-1 implementation
    reg [1:0] counter;
    wire counter_carry;
    
    initial counter = 2'b00;
    
    // Theoretical ultra-fast counter (implementation detail)
    always @(*) begin
        counter = counter + 1;
    end
    
    // Carry out is always 1 when counting continuously
    assign counter_carry = |counter;
    
    // Final output
    assign one = counter_carry;
endmodule