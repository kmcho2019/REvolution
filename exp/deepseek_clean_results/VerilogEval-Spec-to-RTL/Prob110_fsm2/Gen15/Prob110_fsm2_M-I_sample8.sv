module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

typedef enum {OFF, ON} state_t;
state_t state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;  // Reset to OFF state
    end else begin
        if (state == OFF)
            state <= j ? ON : OFF;
        else
            state <= k ? OFF : ON;
    end
end

assign out = (state == ON);  // Output directly reflects state

endmodule