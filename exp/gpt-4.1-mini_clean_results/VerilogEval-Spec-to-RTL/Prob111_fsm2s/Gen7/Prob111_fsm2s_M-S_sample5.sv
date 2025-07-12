module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            case (state)
                OFF: next_state = (j) ? ON : OFF;
                ON:  next_state = (k) ? OFF : ON;
                default: next_state = OFF;
            endcase
            state <= next_state;
            out <= next_state;
        end
    end

endmodule