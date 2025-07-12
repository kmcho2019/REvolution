module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational next state logic
    always @(*) begin
        if (!train_valid) begin
            // Hold current state when not training
            next_state = state;
        end else if (train_taken) begin
            // Increment with saturation at 3
            if (state == 2'd3)
                next_state = 2'd3;
            else
                next_state = state + 1;
        end else begin
            // Decrement with saturation at 0
            if (state == 2'd0)
                next_state = 2'd0;
            else
                next_state = state - 1;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // Weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule