module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0=A, 1=B
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to B
        end else begin
            if (state) begin  // Current state B
                state <= in;  // 1->B, 0->A
            end else begin   // Current state A
                state <= ~in; // 0->B, 1->A
            end
        end
    end
    
    assign out = state;  // B=1, A=0
    
endmodule