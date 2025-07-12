module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

typedef enum bit {OFF = 1'b0, ON = 1'b1} state_t;
state_t state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;  // Asynchronous reset to OFF
    end else begin
        if (state == OFF)
            state <= j ? ON : OFF;
        else
            state <= k ? OFF : ON;
    end
end

assign out = state;  // Direct output from state bit

endmodule