module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    wire [1:0] incremented;
    wire [1:0] decremented;
    wire [1:0] next_state;

    // Increment and decrement with saturation
    assign incremented = (state == 2'b11) ? 2'b11 : (state + 1'b1);
    assign decremented = (state == 2'b00) ? 2'b00 : (state - 1'b1);

    // Next state logic based on train_valid and train_taken
    assign next_state = train_valid ? (train_taken ? incremented : decremented) : state;

    // Sequential block with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            state <= next_state;
        end
    end

endmodule