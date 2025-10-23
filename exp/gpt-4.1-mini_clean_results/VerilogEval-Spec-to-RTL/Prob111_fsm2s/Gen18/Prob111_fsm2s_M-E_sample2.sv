module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Combinational logic for next state
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF; // Safe default
        endcase
    end

    // Sequential logic for state update and synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output logic
    always @(posedge clk) begin
        out <= (state == ON) ? 1'b1 : 1'b0;
    end

endmodule