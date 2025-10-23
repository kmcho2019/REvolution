module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    reg areset_sync; // to detect posedge of areset asynchronously

    // Asynchronous positive edge reset detection
    // Use a flip-flop to detect rising edge of areset asynchronously
    // Then apply reset synchronously in state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            areset_sync <= 1'b1;
        else
            areset_sync <= 1'b0;
    end

    // Saturating counter update
    always @(posedge clk or posedge areset) begin
        if (areset_sync) begin
            state <= 2'b01;  // reset to weakly not-taken
        end else begin
            if (train_valid) begin
                case (train_taken)
                    1'b1: state <= (state == 2'b11) ? 2'b11 : state + 1'b1;
                    1'b0: state <= (state == 2'b00) ? 2'b00 : state - 1'b1;
                endcase
            end else begin
                state <= state; // hold
            end
        end
    end

endmodule