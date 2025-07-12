module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // weakly not-taken initial value
    end else if (train_valid) begin
        if (train_taken) begin
            // Increment saturating at 3 (2'b11)
            if (state != 2'b11)
                state <= state + 1;
            else
                state <= state;
        end else begin
            // Decrement saturating at 0 (2'b00)
            if (state != 2'b00)
                state <= state - 1;
            else
                state <= state;
        end
    end else begin
        // hold state if not training
        state <= state;
    end
end

endmodule