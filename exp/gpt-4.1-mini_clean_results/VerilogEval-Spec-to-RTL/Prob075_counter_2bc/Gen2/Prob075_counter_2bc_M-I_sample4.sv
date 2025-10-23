module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

always @* begin
    next_state = state; // default hold
    if (train_valid) begin
        if (train_taken) begin
            // Saturate at 3
            next_state = (state == 2'b11) ? 2'b11 : state + 1;
        end else begin
            // Saturate at 0
            next_state = (state == 2'b00) ? 2'b00 : state - 1;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule