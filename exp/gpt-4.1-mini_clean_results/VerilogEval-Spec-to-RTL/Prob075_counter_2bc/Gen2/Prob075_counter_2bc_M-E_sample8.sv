module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic for next_state calculation with saturating increment/decrement
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Saturating increment: clamp to 3
                next_state = (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                // Saturating decrement: clamp to 0
                next_state = (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end else begin
            // Hold current state
            next_state = state;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken on reset
        end else begin
            state <= next_state;
        end
    end

endmodule