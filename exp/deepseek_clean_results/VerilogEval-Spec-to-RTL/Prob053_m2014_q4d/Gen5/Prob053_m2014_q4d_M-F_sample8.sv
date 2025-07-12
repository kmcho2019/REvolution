module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d_input;
    
    assign d_input = in ^ out;
    
    initial begin
        out = 0;
    end
    
    always @(posedge clk) begin
        out <= d_input;
    end

endmodule