module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding using localparam for synthesis efficiency
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register and output logic combined (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_state;  // Moore output equals state encoding
        end
    end

endmodule