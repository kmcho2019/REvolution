module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;
    wire update_enable;

    // Update enable is active only when training is valid
    assign update_enable = train_valid;

    // Next state combinational logic with saturating arithmetic
    always @(*) begin
        if (!update_enable) begin
            next_state = state; // hold current state if not training
        end else if (train_taken) begin
            // increment saturating at 3
            if (state == 2'd3)
                next_state = 2'd3;
            else
                next_state = state + 1'b1;
        end else begin
            // decrement saturating at 0
            if (state == 2'd0)
                next_state = 2'd0;
            else
                next_state = state - 1'b1;
        end
    end

    // Sequential state register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset value
        else if (update_enable)
            state <= next_state;
        // else hold state unchanged
    end

endmodule