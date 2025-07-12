module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    always @* begin
        // Default: hold current state
        next_state = state;

        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state != 2'b11)
                    next_state = state + 1'b1;
            end else begin
                // Decrement saturating at 0
                if (state != 2'b00)
                    next_state = state - 1'b1;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else begin
            state <= next_state;
        end
    end

endmodule