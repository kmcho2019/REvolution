module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding with localparam for readability and synthesis friendliness
    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state;
    reg next_state;

    // Combinational next state logic based on current state and inputs
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Sequential logic: state register and output update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_state;  // output assigned from next_state to reflect Moore output one clock cycle after input change
        end
    end

endmodule