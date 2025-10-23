module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        state <= reset ? OFF : next_state;
    end

    // Output logic
    assign out = state;

endmodule