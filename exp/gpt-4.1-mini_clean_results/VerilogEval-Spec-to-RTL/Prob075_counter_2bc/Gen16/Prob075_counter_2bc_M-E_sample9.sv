module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Intermediate signals for increment/decrement with saturation
    wire [2:0] incremented = (state == 2'b11) ? 3'b011 : {1'b0, state} + 3'b001;
    wire [2:0] decremented = (state == 2'b00) ? 3'b000 : {1'b0, state} - 3'b001;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // reset to weakly not-taken
        end else if (train_valid) begin
            if (train_taken)
                state <= incremented[1:0];
            else
                state <= decremented[1:0];
        end
        // else hold current state
    end

endmodule