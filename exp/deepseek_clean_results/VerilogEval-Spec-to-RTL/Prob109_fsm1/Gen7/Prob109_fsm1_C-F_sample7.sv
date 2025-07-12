module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Clear state definitions with parameters
    parameter STATE_A = 1'b0;
    parameter STATE_B = 1'b1;
    
    reg state;
    
    // State transition logic with case statement
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;  // Async reset to STATE_B
        end else begin
            case (state)
                STATE_A: state <= in ? STATE_A : STATE_B;
                STATE_B: state <= in ? STATE_B : STATE_A;
            endcase
        end
    end
    
    // Explicit Moore output definition
    assign out = (state == STATE_B);
    
endmodule