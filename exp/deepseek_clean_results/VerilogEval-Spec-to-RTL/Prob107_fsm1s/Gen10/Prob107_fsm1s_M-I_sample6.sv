module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    reg current_state; // 0=B, 1=A
    
    // State transition and output
    always @(posedge clk) begin
        if (reset) begin
            current_state <= 1'b0; // State B
        end else begin
            case (current_state)
                1'b0: current_state <= in ? 1'b0 : 1'b1; // State B transitions
                1'b1: current_state <= in ? 1'b1 : 1'b0; // State A transitions
            endcase
        end
    end
    
    // Output logic (Moore)
    assign out = ~current_state; // out=1 when in state B (0)
    
endmodule