module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to weakly not-taken
    end else if (train_valid) begin
        if (train_taken) begin
            state <= (state == 2'b11) ? 2'b11 : state + 1; // saturating increment
        end else begin
            state <= (state == 2'b00) ? 2'b00 : state - 1; // saturating decrement
        end
    end
end

endmodule