module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // State encoding using local parameters for clarity
    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state, next_state;

    // Combinational next state logic using case statement
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State and output register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= (next_state == ON) ? 1'b1 : 1'b0;
        end
    end

endmodule