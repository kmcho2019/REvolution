module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    wire [2:0] next_state_unbounded;
    wire [1:0] next_state_saturated;
    wire clk_en;

    assign clk_en = train_valid;

    // Compute next state before saturation
    assign next_state_unbounded = state + (train_taken ? 3'd1 : -3'd1);

    // Saturate between 0 and 3
    assign next_state_saturated = (next_state_unbounded[2]) ? 2'b00 :  // Negative, saturate to 0
                                  (next_state_unbounded > 3) ? 2'b11 : // Overflow, saturate to 3
                                  next_state_unbounded[1:0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset value
        end else if (clk_en) begin
            state <= next_state_saturated;
        end
        // else hold current state
    end

endmodule