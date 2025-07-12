module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    wire [1:0] incr_state;
    wire [1:0] decr_state;
    wire [1:0] next_state;

    // Saturated increment: if state < 3 then state + 1 else 3
    assign incr_state = (state == 2'b11) ? 2'b11 : state + 1'b1;
    // Saturated decrement: if state > 0 then state - 1 else 0
    assign decr_state = (state == 2'b00) ? 2'b00 : state - 1'b1;

    // Choose next state based on train_taken
    assign next_state = train_taken ? incr_state : decr_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold state unchanged
    end

endmodule