module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [1:0] next_state;

    // Compute next state with saturation arithmetic
    assign next_state = train_valid ? 
                        (train_taken ? 
                            ((state == 2'd3) ? 2'd3 : state + 2'd1) : 
                            ((state == 2'd0) ? 2'd0 : state - 2'd1))
                        : state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else begin
            state <= next_state;
        end
    end

endmodule