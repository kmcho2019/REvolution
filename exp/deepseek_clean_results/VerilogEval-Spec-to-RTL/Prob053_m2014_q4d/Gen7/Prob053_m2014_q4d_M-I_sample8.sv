module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out;
    
    assign xor_out = in ^ out;
    
    initial begin
        out = 1'b0;  // Initialize to known state
    end
    
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule