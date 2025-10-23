module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

reg [1:0] nextState;

always @* begin
    if (train_valid) begin
        if (train_taken) begin
            nextState = (state == 2'b11) ? 2'b11 : state + 1'b1;
        end else begin
            nextState = (state == 2'b00) ? 2'b00 : state - 1'b1;
        end
    end else begin
        nextState = state;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else begin
        state <= nextState;
    end
end

endmodule