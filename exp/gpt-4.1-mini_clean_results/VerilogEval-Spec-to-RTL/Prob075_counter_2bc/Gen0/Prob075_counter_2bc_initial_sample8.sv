module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    // Asynchronous positive edge reset with synchronous update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                if (state != 2'b11)
                    state <= state + 1'b1;
                else
                    state <= 2'b11; // saturate at 3
            end else begin
                if (state != 2'b00)
                    state <= state - 1'b1;
                else
                    state <= 2'b00; // saturate at 0
            end
        end
        // if train_valid == 0, state remains unchanged
    end

endmodule