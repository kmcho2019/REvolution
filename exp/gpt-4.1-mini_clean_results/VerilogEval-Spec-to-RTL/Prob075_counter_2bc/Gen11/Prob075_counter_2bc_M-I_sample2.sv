module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    // Saturating counter with simple increment/decrement using arithmetic with saturation
    wire [2:0] inc = state + 3'd1; // 3 bits to detect overflow > 3
    wire [2:0] dec = state - 3'd1; // underflow < 0 detected by MSB

    reg [1:0] next_state;

    always @(*) begin
        if (!train_valid) begin
            next_state = state; // hold state
        end else if (train_taken) begin
            // increment saturating at 3
            next_state = (inc[2] || inc[1:0] == 2'b11) ? 2'b11 : inc[1:0];
        end else begin
            // decrement saturating at 0
            next_state = (state == 2'b00) ? 2'b00 : dec[1:0];
        end
    end

    // Update state only when train_valid=1 or on asynchronous reset to reduce toggle power
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold state without update to reduce unnecessary toggling
    end

endmodule