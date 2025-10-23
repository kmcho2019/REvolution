module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out;
    
    // Combinational XOR logic
    assign xor_out = in ^ out;
    
    // Sequential flip-flop
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule