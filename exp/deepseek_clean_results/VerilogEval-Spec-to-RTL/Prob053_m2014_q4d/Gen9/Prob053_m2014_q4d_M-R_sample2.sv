module TopModule (
    input clk,
    input in,
    output reg out
);

    wire feedback_xor;
    
    // XOR of input and current output
    assign feedback_xor = in ^ out;
    
    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        out <= feedback_xor;
    end

endmodule