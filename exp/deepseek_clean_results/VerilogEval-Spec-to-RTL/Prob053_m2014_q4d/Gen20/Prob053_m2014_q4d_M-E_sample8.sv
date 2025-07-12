module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out;
    
    // Continuous XOR feedback
    assign xor_out = in ^ out;
    
    // Clocked sampling
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule