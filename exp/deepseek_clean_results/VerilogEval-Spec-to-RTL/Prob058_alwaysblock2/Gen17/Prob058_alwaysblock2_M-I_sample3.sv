module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Shared XOR logic for combinational paths
    wire xor_result = a ^ b;
    
    // Method 1: Continuous assignment using shared logic
    assign out_assign = xor_result;
    
    // Method 2: Combinational always block using shared logic
    assign out_always_comb = xor_result;
    
    // Method 3: Sequential implementation with input change detection
    reg a_prev, b_prev;
    always_ff @(posedge clk) begin
        a_prev <= a;
        b_prev <= b;
        
        // Only update output when inputs change
        if ((a != a_prev) || (b != b_prev)) begin
            out_always_ff <= xor_result;
        end
    end

endmodule