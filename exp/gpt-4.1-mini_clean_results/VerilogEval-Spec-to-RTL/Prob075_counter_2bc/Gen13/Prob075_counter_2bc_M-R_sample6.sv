module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    wire [1:0] next_state;

    // Combinational logic for next state with saturating increment/decrement
    assign next_state = (train_valid) ?
                        (train_taken ? ((state < 2'd3) ? state + 1 : 2'd3)
                                     : ((state > 2'd0) ? state - 1 : 2'd0))
                        : state;

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else begin
            state <= next_state;
        end
    end

endmodule