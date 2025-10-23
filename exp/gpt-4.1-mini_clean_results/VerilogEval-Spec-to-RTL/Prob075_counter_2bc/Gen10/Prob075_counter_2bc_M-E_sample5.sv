module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else if (train_valid) begin
            if (train_taken && state != 2'd3)
                state <= state + 1;
            else if (!train_taken && state != 2'd0)
                state <= state - 1;
            else
                state <= state; // no change if at saturation
        end
        else
            state <= state; // hold state if train_valid is low
    end

endmodule