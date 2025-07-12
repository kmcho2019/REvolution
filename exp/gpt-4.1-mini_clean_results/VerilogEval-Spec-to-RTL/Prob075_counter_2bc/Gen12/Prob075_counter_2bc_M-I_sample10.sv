module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    wire [2:0] incremented; // 3-bit to detect saturation
    wire [2:0] decremented;
    wire [1:0] next_state;

    // Arithmetic increment/decrement with saturation
    assign incremented = {1'b0, state} + 3'b001;
    assign decremented = {1'b0, state} - 3'b001;

    // Compute next state based on train_valid and train_taken
    assign next_state = (train_valid) ? 
                        (train_taken ? 
                            ((incremented > 3) ? 2'b11 : incremented[1:0]) // saturate max at 3
                            :
                            ((decremented[2] == 1'b1) ? 2'b00 : decremented[1:0]) // saturate min at 0, check borrow bit
                        )
                        : state;

    // State update with asynchronous positive edge reset and clock enable (CE)
    // Only update state when train_valid=1 to reduce toggling and power
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else retain current state, no toggle
    end

endmodule