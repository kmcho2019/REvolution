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
                // Saturating increment
                if (state < 2'd3)
                    next_state = state + 1;
                else
                    next_state = 2'd3;
            end else begin
                // Saturating decrement
                if (state > 2'd0)
                    next_state = state - 1;
                else
                    next_state = 2'd0;
            end
        end else begin
            // Hold state when not training
            next_state = state;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule