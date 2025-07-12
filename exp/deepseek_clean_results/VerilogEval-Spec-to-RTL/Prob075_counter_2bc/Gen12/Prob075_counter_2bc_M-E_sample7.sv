module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Reset value is weakly not-taken (2'b01)
localparam RESET_STATE = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= RESET_STATE;
    end else if (train_valid) begin
        // Increment with upper saturation at 3
        if (train_taken && state != 2'b11) begin
            state <= state + 1'b1;
        end
        // Decrement with lower saturation at 0
        else if (!train_taken && state != 2'b00) begin
            state <= state - 1'b1;
        end
        // Else keep current value (implicit)
    end
    // Else keep current value (implicit)
end

endmodule