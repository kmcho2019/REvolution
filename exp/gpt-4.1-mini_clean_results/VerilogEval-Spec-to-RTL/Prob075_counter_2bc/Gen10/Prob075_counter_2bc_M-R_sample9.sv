module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic to determine next state
    always @(*) begin
        if (!train_valid) begin
            next_state = state;
        end else if (train_taken) begin
            // Saturating increment
            if (state == 2'd3)
                next_state = 2'd3;
            else
                next_state = state + 2'd1;
        end else begin
            // Saturating decrement
            if (state == 2'd0)
                next_state = 2'd0;
            else
                next_state = state - 2'd1;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            state <= next_state;
        end
        // else hold state implicitly
    end

endmodule