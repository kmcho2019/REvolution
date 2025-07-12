module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;

    // Sequential state update with combined transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
        end
    end

    // Output logic
    assign out = state;

endmodule