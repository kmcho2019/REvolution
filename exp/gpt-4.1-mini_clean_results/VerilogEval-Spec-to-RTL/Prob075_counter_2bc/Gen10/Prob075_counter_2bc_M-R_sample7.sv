module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    reg [1:0] next_state;

    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state < 2'd3)
                    next_state = state + 2'd1;
                else
                    next_state = 2'd3;
            end else begin
                // Decrement saturating at 0
                if (state > 2'd0)
                    next_state = state - 2'd1;
                else
                    next_state = 2'd0;
            end
        end else begin
            next_state = state; // hold current state
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule