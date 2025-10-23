module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding with localparam for synthesis-friendly style
    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state;
    reg next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            OFF: next_state = (j == 1'b1) ? ON : OFF;
            ON:  next_state = (k == 1'b1) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with synchronous reset and combined output logic
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output driven continuously from state (Moore)
    assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule