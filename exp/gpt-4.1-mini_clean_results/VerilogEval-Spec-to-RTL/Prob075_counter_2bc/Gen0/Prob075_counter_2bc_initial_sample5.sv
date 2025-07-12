module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    // Define next_state register for cleaner sequential logic
    reg [1:0] next_state;

    // Combinational logic to compute next_state based on current state and inputs
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state < 2'd3)
                    next_state = state + 2'd1;
                else
                    next_state = state;
            end else begin
                // Decrement saturating at 0
                if (state > 2'd0)
                    next_state = state - 2'd1;
                else
                    next_state = state;
            end
        end else begin
            // No training, keep state
            next_state = state;
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else begin
            state <= next_state;
        end
    end

endmodule