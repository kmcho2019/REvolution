module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    // Asynchronous positive edge reset with synchronous updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                if (state != 2'b11)
                    state <= state + 1;
            end else begin
                if (state != 2'b00)
                    state <= state - 1;
            end
        end
        // else keep state unchanged
    end

endmodule