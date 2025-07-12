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
            state <= in;    // Next state is simply the input
        end
    end
    
    assign out = state;  // Output is the state directly
    
endmodule