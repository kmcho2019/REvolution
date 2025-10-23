module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [1:0] next_state;

    // Combinational logic for next_state based on current state and inputs
    assign next_state = (train_valid) ?
                        (train_taken ?
                         ((state == 2'd3) ? 2'd3 : state + 1) :
                         ((state == 2'd0) ? 2'd0 : state - 1))
                        : state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else
            state <= next_state;
    end

endmodule