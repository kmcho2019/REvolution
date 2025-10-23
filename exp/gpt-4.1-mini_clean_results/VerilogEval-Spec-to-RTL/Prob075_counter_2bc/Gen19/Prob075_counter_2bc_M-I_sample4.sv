module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [2:0] incremented, decremented;

    // Calculate increment and decrement with saturating boundaries
    assign incremented = (state == 2'b11) ? 3'b011 : {1'b0, state} + 3'b001; // saturate at 3
    assign decremented = (state == 2'b00) ? 3'b000 : {1'b0, state} - 3'b001; // saturate at 0

    wire [1:0] next_state;

    // Select next state based on train_taken when train_valid is high, else hold state
    assign next_state = train_valid ? (train_taken ? incremented[1:0] : decremented[1:0]) : state;

    // Sequential logic with async positive edge reset; update state only when train_valid is high (enable)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold current state (no toggling)
    end

endmodule