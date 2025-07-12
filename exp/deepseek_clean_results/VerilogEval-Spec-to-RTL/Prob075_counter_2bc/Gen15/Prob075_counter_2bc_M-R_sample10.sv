module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Reset state is weakly not-taken (2'b01)
parameter RESET_STATE = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= RESET_STATE;
    end
    else if (train_valid) begin
        if (train_taken) begin
            // Increment with saturation at 3 (2'b11)
            state <= (state == 2'b11) ? 2'b11 : state + 1;
        end
        else begin
            // Decrement with saturation at 0 (2'b00)
            state <= (state == 2'b00) ? 2'b00 : state - 1;
        end
    end
    // else hold state when not training
end

endmodule