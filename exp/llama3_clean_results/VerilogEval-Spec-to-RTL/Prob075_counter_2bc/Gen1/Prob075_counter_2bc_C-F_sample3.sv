module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to 2'b01
        state <= 2'b01;
    end else if (train_valid) begin
        // Increment up to a maximum of 3
        state <= (train_taken) ? (state == 2'b11) ? 2'b11 : state + 1'b1 : (state == 2'b00) ? 2'b00 : state - 1'b1;
    end else begin
        // Keep the counter unchanged when not training
        state <= state;
    end
end

endmodule