module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Weakly not-taken state
    end
    else if (train_valid) begin
        // Increment if taken (but saturate at 3)
        if (train_taken && (state != 2'b11)) begin
            state <= state + 1;
        end
        // Decrement if not taken (but saturate at 0)
        else if (!train_taken && (state != 2'b00)) begin
            state <= state - 1;
        end
        // Otherwise maintain current state
    end
    // else maintain current state
end

endmodule