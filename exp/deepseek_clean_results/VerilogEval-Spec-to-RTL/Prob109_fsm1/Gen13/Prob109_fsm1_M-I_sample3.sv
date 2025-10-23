module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    reg state; // 0=A, 1=B
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Reset to B
            out <= 1'b1;
        end
        else begin
            state <= (state & in) | (~state & ~in);
            out <= state;
        end
    end
    
endmodule