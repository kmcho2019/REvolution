module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State definitions (OFF=0, ON=1)
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    // State register
    reg state;

    // Synchronous state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;  // Active-high sync reset
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;  // J=1 moves to ON
                ON:  state <= k ? OFF : ON;  // K=1 moves to OFF
            endcase
        end
    end

    // Moore output (directly from state)
    assign out = state;

endmodule