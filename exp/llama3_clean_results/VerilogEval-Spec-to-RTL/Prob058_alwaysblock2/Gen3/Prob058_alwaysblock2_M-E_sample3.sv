module TopModule(
    input clk,
    input a,
    input b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    always @(posedge clk or a or b) begin
        // Directly assign out_assign based on XOR of a and b
        out_assign = a ^ b;
        
        // Assign out_always_comb within the always block for combinational logic
        out_always_comb = a ^ b;
        
        // Update out_always_ff only on the positive edge of the clock for flip-flop behavior
        if (posedge clk) begin
            out_always_ff = a ^ b;
        end
    end

endmodule