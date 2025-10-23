module TopModule (
    input clk,
    input in,
    input reset_n,  // Active-low asynchronous reset
    output reg out
);

    wire xor_out;
    
    assign xor_out = in ^ out;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            out <= 1'b0;  // Reset to known state
        end
        else begin
            out <= xor_out;
        end
    end

endmodule