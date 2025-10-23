module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    reg [1:0] next_state;

    // Combinational logic to determine next state with saturating increment/decrement
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Saturating increment
                next_state = (state == 2'd3) ? 2'd3 : state + 2'd1;
            end else begin
                // Saturating decrement
                next_state = (state == 2'd0) ? 2'd0 : state - 2'd1;
            end
        end else begin
            // Hold current state
            next_state = state;
        end
    end

    // Sequential logic: state register update with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule