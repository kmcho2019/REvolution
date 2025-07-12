module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    reg [1:0] next_state;

    always @(*) begin
        if (!train_valid) begin
            // Hold current state
            next_state = state;
        end else begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state == 2'b11)
                    next_state = 2'b11;
                else
                    next_state = state + 2'b01;
            end else begin
                // Decrement saturating at 0
                if (state == 2'b00)
                    next_state = 2'b00;
                else
                    next_state = state - 2'b01;
            end
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken
        else
            state <= next_state;
    end

endmodule