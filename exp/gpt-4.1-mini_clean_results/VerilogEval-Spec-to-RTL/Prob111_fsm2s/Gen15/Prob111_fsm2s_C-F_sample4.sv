module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding using localparams for clarity
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Sequential logic: synchronous reset and state update with integrated next state logic
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
                default: state <= OFF; // Defensive fallback
            endcase
        end
    end

    // Moore output directly driven from state register (no separate output register)
    assign out = state;

endmodule