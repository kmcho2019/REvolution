module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // Define states as enum
    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            case (state)
                OFF: begin
                    state <= j ? ON : OFF;
                    out <= j ? 1'b1 : 1'b0;
                end
                ON: begin
                    state <= k ? OFF : ON;
                    out <= k ? 1'b0 : 1'b1;
                end
            endcase
        end
    end

endmodule