module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding using localparam
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // State register and next state logic combined
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Output logic as a continuous assignment (Moore)
    assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule