module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out;
    reg initialized = 1'b0;
    
    assign xor_out = in ^ out;
    
    always @(posedge clk) begin
        if (!initialized) begin
            out <= 1'b0;
            initialized <= 1'b1;
        end
        else begin
            out <= xor_out;
        end
    end

endmodule