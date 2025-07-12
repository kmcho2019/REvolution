module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire increment = train_valid & train_taken;
    wire decrement = train_valid & (~train_taken);

    wire [1:0] next_state;

    // Saturating increment/decrement logic without wider bitwidth arithmetic:
    // - increment if train_valid & train_taken and state < 3
    // - decrement if train_valid & ~train_taken and state > 0
    // - hold state otherwise
    assign next_state = (increment && (state != 2'b11)) ? (state + 1) :
                        (decrement && (state != 2'b00)) ? (state - 1) :
                        state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold current state to avoid unnecessary toggling
    end

endmodule