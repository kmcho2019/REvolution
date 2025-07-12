module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    reg state;  // 0=B, 1=A (most compact encoding for 2 states)
    
    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // State B transitions
                1'b1: state <= in ? 1'b1 : 1'b0;  // State A transitions
            endcase
        end
    end
    
    // Output logic (Moore)
    assign out = ~state;  // out=1 when in state B (0), out=0 when in state A (1)
    
endmodule