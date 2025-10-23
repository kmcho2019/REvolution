module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    // Asynchronous positive edge reset for state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not taken
        end else if (train_valid) begin
            if (train_taken) begin
                if (state != 2'b11)
                    state <= state + 1'b1;
                else
                    state <= state;
            end else begin
                if (state != 2'b00)
                    state <= state - 1'b1;
                else
                    state <= state;
            end
        end else begin
            state <= state;
        end
    end

endmodule