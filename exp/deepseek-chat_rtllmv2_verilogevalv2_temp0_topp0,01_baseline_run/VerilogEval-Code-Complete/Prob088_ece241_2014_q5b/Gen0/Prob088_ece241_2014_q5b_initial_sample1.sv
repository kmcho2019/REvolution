module TopModule (
  input clk,
  input areset,
  input x,
  output z
);
    reg state_A, state_B;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            if (state_A) begin
                state_A <= ~x;
                state_B <= x;
            end
            else if (state_B) begin
                state_A <= 1'b0;
                state_B <= 1'b1;
            end
        end
    end
    
    assign z = (state_A & x) | (state_B & ~x);
endmodule