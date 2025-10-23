module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
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
            // Moore output depends only on the current state (after update)
            out <= (next_state == ON);
        end
    end

endmodule