module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic to compute next state with saturation
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment with saturation at 3
                if (state == 2'b11)
                    next_state = 2'b11;
                else
                    next_state = state + 1;
            end else begin
                // Decrement with saturation at 0
                if (state == 2'b00)
                    next_state = 2'b00;
                else
                    next_state = state - 1;
            end
        end else begin
            // Hold current state if not training
            next_state = state;
        end
    end

    // Sequential logic: asynchronous positive-edge reset, synchronous update of state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else begin
            state <= next_state;
        end
    end

endmodule