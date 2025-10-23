module TopModule (
    input        clk,
    input        areset,
    input        train_valid,
    input        train_taken,
    output reg [1:0] state
);

    reg [1:0] next_state;

    // Combinational block to determine next state
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state == 2'b11)
                    next_state = 2'b11;
                else
                    next_state = state + 1'b1;
            end else begin
                // Decrement saturating at 0
                if (state == 2'b00)
                    next_state = 2'b00;
                else
                    next_state = state - 1'b1;
            end
        end else begin
            // Hold state when not valid
            next_state = state;
        end
    end

    // Sequential block with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken initial state
        end else begin
            state <= next_state;
        end
    end

endmodule