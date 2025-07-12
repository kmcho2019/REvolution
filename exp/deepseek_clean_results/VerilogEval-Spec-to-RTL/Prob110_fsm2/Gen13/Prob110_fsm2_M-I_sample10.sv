module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // Using enum for better code readability
    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    state_t state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            unique case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
        end
    end

    // Output logic - pure Moore (direct state assignment)
    assign out = state;

endmodule