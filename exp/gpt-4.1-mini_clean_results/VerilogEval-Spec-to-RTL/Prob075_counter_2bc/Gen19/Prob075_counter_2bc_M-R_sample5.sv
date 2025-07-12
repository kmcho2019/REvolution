module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational next state logic with saturation
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state == 2'b11)
                    next_state = 2'b11;
                else
                    next_state = state + 1;
            end else begin
                // Decrement saturating at 0
                if (state == 2'b00)
                    next_state = 2'b00;
                else
                    next_state = state - 1;
            end
        end else begin
            next_state = state; // Hold state if not valid
        end
    end

    // Sequential logic with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset value
        else
            state <= next_state;
    end

endmodule