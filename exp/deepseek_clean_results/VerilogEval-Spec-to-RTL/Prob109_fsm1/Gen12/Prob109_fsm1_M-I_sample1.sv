module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state; // 0=A, 1=B
    
    // Next state logic using case for better synthesis
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // Reset to B
        else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1; // A transitions
                1'b1: state <= in ? 1'b1 : 1'b0; // B transitions
            endcase
        end
    end
    
    // Output is just the state bit (B=1)
    assign out = state;
    
endmodule