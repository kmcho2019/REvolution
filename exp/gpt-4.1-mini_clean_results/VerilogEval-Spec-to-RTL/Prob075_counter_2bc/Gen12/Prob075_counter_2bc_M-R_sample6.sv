module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [1:0] next_state;
    wire       update_en;

    // Calculate next_state combinationally with saturating increment/decrement
    assign next_state = train_taken
                        ? ((state == 2'b11) ? 2'b11 : state + 2'b01)
                        : ((state == 2'b00) ? 2'b00 : state - 2'b01);

    // Enable update only if train_valid and state changes to reduce toggling
    assign update_en = train_valid && (next_state != state);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (update_en) begin
            state <= next_state;
        end
        // else keep state unchanged
    end

endmodule