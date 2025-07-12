module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Directly assign the XOR output
    assign out_assign = a ^ b;
    
    // Implement combinational logic using always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Implement the flip-flop logic for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule