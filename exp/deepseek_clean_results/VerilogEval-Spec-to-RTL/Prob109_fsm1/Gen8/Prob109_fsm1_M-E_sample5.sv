module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state_counter;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_counter <= 1'b1;  // Reset to state B
        end else begin
            // Arithmetic state transitions
            state_counter <= state_counter + (state_counter ? in : ~in);
        end
    end
    
    assign out = state_counter;
    
endmodule