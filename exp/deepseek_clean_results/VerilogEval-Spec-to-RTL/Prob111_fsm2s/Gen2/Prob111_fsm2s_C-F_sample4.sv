module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State definitions (binary encoding)
    parameter OFF = 1'b0;  // Output = 0
    parameter ON  = 1'b1;  // Output = 1

    // State register
    reg state;

    // Synchronous state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;  // Active-high synchronous reset
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;  // J=1: OFF→ON, J=0: stay OFF
                ON:  state <= k ? OFF : ON;  // K=1: ON→OFF, K=0: stay ON
            endcase
        end
    end

    // Moore output (directly from current state)
    assign out = state;

endmodule