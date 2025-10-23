module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding with localparams
    localparam OFF = 1'b0, ON = 1'b1;

    reg state, next_state;

    // Next state combinational logic as continuous assignment
    // Use a combinational always block for next_state to keep clarity
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic as continuous assignment (Moore output depends on current state only)
    assign out = (state == ON);

endmodule