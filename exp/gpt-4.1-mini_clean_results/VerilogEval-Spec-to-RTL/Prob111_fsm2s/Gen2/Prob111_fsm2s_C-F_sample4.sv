module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding using localparams for synthesis friendliness and minimal area
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Sequential logic: state and output registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= state;  // output depends on current state (Moore)
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON  : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

endmodule