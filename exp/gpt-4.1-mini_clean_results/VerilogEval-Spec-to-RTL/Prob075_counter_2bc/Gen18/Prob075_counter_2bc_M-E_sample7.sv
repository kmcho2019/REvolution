module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    reg [2:0] temp_state; // 3 bits to detect overflow

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                // increment saturating at 3
                temp_state = state + 1;
                state <= (temp_state > 3) ? 2'b11 : temp_state[1:0];
            end else begin
                // decrement saturating at 0
                temp_state = state - 1;
                state <= (state == 0) ? 2'b00 : temp_state[1:0];
            end
        end else begin
            // hold state when train_valid=0
            state <= state;
        end
    end

endmodule