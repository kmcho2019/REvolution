module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    wire update_enable;
    wire [1:0] next_state_inc;
    wire [1:0] next_state_dec;

    // Saturate increment at 3
    assign next_state_inc = (state == 2'd3) ? 2'd3 : (state + 1);
    // Saturate decrement at 0
    assign next_state_dec = (state == 2'd0) ? 2'd0 : (state - 1);

    // Enable update only when train_valid and state will change
    assign update_enable = train_valid && (
                               (train_taken && (state != 2'd3)) ||
                               (~train_taken && (state != 2'd0))
                           );

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (update_enable) begin
            if (train_taken)
                state <= next_state_inc;
            else
                state <= next_state_dec;
        end
        // else keep state unchanged
    end

endmodule