module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Combined next-state and output logic
    always @(*) begin
        case (state)
            OFF: begin
                out = 1'b0;
                next_state = j ? ON : OFF;
            end
            ON: begin
                out = 1'b1;
                next_state = k ? OFF : ON;
            end
            default: begin
                out = 1'b0;
                next_state = OFF;
            end
        endcase
    end

endmodule