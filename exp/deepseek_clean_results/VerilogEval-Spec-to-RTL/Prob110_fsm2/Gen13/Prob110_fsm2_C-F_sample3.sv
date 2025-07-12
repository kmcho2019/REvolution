module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding with localparam for maximum clarity
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;  // Current state register

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;  // Async reset to OFF state
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;  // Transition on j
                ON:  state <= k ? OFF : ON;  // Transition on k
            endcase
        end
    end

    // Output assignment (pure Moore machine)
    assign out = state;

endmodule