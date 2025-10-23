module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d_input;
    
    // XOR of input and current output
    assign d_input = in ^ out;
    
    // D flip-flop implementation
    always @(posedge clk) begin
        out <= d_input;
    end

endmodule