module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    // Asynchronous positive edge reset, synchronous update of counter
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state < 2'b11)
                    state <= state + 1;
                else
                    state <= 2'b11;
            end else begin
                // Decrement saturating at 0
                if (state > 2'b00)
                    state <= state - 1;
                else
                    state <= 2'b00;
            end
        end
        // else hold state
    end

endmodule