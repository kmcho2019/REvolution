module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic for next state using saturating arithmetic
    always @(*) begin
        if (!train_valid) begin
            next_state = state; // hold state if no training
        end else if (train_taken) begin
            // increment with saturation at 3
            next_state = (state == 2'd3) ? 2'd3 : state + 1'b1;
        end else begin
            // decrement with saturation at 0
            next_state = (state == 2'd0) ? 2'd0 : state - 1'b1;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // reset to weakly not-taken
        end else begin
            state <= next_state;
        end
    end

endmodule