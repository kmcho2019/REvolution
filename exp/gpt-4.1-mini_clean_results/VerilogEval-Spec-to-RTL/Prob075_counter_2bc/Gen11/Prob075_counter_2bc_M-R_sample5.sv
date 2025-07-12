module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    wire [2:0] incremented;
    wire [2:0] decremented;
    wire [2:0] candidate_next;

    // Increment saturating at 3 (2'b11)
    assign incremented = (state == 2'b11) ? 3'b011 : (state + 1);

    // Decrement saturating at 0 (2'b00)
    assign decremented = (state == 2'b00) ? 3'b000 : (state - 1);

    // Select candidate next state based on train_taken
    assign candidate_next = train_taken ? incremented : decremented;

    // Final next state logic respects train_valid signal
    wire [1:0] next_state = train_valid ? candidate_next[1:0] : state;

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken
        end else begin
            state <= next_state;
        end
    end

endmodule