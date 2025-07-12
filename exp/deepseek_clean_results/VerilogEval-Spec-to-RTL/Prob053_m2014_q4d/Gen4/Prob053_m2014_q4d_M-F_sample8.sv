module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out;
    
    assign xor_out = in ^ out;  // Combinational XOR
    
    always @(posedge clk) begin
        out <= xor_out;         // Sequential flip-flop
    end

endmodule