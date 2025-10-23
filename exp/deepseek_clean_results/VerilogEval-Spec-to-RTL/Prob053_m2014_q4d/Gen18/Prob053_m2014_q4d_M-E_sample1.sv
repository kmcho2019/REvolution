module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out;
    
    // XOR of input and current output
    assign xor_out = in ^ out;
    
    // D flip-flop with XOR feedback
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule