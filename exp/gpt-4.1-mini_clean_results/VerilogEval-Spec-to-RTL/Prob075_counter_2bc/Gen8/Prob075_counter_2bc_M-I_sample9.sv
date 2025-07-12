module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire        enable = train_valid;
    reg  [1:0]  next_state;

    // Compute next_state combinationally with saturating increment/decrement
    always @* begin
        if (train_taken) begin
            // Saturating increment: cap at 3
            next_state = (state == 2'd3) ? 2'd3 : state + 1;
        end else begin
            // Saturating decrement: floor at 0
            next_state = (state == 2'd0) ? 2'd0 : state - 1;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // weakly not-taken reset state
        else if (enable)
            state <= next_state;
        // else hold state unchanged
    end

endmodule