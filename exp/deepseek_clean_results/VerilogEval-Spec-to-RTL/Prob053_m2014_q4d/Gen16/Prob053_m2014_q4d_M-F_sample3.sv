module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d_input;
    
    // Combinational XOR feedback
    assign d_input = in ^ out;
    
    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        out <= d_input;
    end

endmodule