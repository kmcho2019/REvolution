module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State transition logic
    always @(*) begin
        case (state)
            OFF: state = j ? ON : OFF;
            ON:  state = k ? OFF : ON;
        endcase
    end

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output
    assign out = state;

endmodule