module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    reg [1:0] next_state;

    // Combinational next state logic
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state < 2'b11)
                    next_state = state + 1;
                else
                    next_state = 2'b11;
            end else begin
                // Decrement saturating at 0
                if (state > 2'b00)
                    next_state = state - 1;
                else
                    next_state = 2'b00;
            end
        end else begin
            next_state = state; // hold state if not valid
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule