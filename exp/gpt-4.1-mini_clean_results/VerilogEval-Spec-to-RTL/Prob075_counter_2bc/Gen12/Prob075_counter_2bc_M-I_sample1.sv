module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    reg [1:0] next_state;

    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Saturate increment
                if (state == 2'd3)
                    next_state = 2'd3;
                else
                    next_state = state + 2'd1;
            end else begin
                // Saturate decrement
                if (state == 2'd0)
                    next_state = 2'd0;
                else
                    next_state = state - 2'd1;
            end
        end else begin
            next_state = state;
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