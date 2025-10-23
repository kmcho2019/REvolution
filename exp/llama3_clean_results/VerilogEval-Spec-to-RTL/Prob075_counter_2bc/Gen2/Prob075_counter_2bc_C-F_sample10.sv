module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

always @(*) begin
    if (train_valid) begin
        next_state = (train_taken) ? (state == 2'b11) ? 2'b11 : state + 1'b1 : (state == 2'b00) ? 2'b00 : state - 1'b1;
    end else begin
        next_state = state;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else begin
        state <= next_state;
    end
end

endmodule