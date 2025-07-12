module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0, ON = 1'b1;
    
    reg state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF; // safety
        endcase
    end

    // State and output update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= (next_state == ON); // Moore output based on next state to avoid delay
        end
    end

endmodule