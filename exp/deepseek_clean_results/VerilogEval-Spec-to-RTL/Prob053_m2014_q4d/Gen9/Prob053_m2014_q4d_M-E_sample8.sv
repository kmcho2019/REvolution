module TopModule (
    input clk,
    input in,
    output reg out
);

    wire intermediate;
    wire final_xor;
    reg delayed_out;
    
    // First XOR stage: input ^ delayed output
    assign intermediate = in ^ delayed_out;
    
    // Second XOR stage: intermediate ^ current output
    assign final_xor = intermediate ^ out;
    
    always @(posedge clk) begin
        delayed_out <= out;  // Create one-cycle delayed version
        out <= final_xor;    // Update flip-flop
    end

endmodule