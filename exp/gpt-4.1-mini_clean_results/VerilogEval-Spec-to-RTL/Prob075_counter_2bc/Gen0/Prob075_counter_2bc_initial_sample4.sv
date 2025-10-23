module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    // Asynchronous positive edge reset triggers counter to 2'b01
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (state < 2'b11)
                    state <= state + 1'b1;
                else
                    state <= state;
            end else begin
                // Decrement saturating at 0
                if (state > 2'b00)
                    state <= state - 1'b1;
                else
                    state <= state;
            end
        end
        // else no change
    end

endmodule