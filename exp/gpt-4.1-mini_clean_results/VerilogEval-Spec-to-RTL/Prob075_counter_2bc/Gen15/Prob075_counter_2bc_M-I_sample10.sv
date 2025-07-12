module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    reg [1:0] next_state;

    always @* begin
        if (!train_valid) begin
            next_state = state; // hold current state
        end else if (train_taken) begin
            // saturate increment at 3
            next_state = (state == 2'd3) ? 2'd3 : state + 2'd1;
        end else begin
            // saturate decrement at 0
            next_state = (state == 2'd0) ? 2'd0 : state - 2'd1;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else begin
            state <= next_state;
        end
    end

endmodule