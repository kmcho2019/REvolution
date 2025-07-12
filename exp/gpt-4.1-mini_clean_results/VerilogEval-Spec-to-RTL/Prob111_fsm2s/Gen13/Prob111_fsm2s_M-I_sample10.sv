module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0, ON = 1'b1;

    reg state, next_state;

    // Sequential logic: synchronous reset, state update, and output register
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            case (state)
                OFF: begin
                    if (j)
                        next_state = ON;
                    else
                        next_state = OFF;
                end
                ON: begin
                    if (k)
                        next_state = OFF;
                    else
                        next_state = ON;
                end
                default: next_state = OFF;
            endcase
            state <= next_state;
            out <= (next_state == ON); // Moore output registered
        end
    end

endmodule