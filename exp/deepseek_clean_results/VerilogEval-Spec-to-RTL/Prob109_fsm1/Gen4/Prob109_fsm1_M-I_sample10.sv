module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions with explicit width
    parameter STATE_A = 1'b0;
    parameter STATE_B = 1'b1;
    
    reg state;
    
    // State transition logic using case for better synthesis
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_A: state <= in ? STATE_A : STATE_B;
                STATE_B: state <= in ? STATE_B : STATE_A;
                default: state <= STATE_B;
            endcase
        end
    end
    
    // Direct output assignment - no extra logic needed
    assign out = state;
    
endmodule