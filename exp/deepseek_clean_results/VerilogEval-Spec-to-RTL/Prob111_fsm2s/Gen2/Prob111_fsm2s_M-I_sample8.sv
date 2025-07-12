module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // Define states
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    // State register
    reg state;

    // Next state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= OFF;
        end
        else begin
            case (state)
                OFF: begin
                    state <= j ? ON : OFF;
                    out <= j ? ON : OFF;
                end
                ON: begin
                    state <= k ? OFF : ON;
                    out <= k ? OFF : ON;
                end
            endcase
        end
    end

endmodule