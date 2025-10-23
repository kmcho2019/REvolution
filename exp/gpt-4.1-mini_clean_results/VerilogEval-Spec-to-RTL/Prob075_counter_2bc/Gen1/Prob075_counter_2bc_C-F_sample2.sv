module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

always @(*) begin
    next_state = state; // default hold
    if (train_valid) begin
        if (train_taken) begin
            if (state != 2'b11)
                next_state = state + 1'b1;
        end else begin
            if (state != 2'b00)
                next_state = state - 1'b1;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // weakly not-taken reset state
    else
        state <= next_state;
end

endmodule