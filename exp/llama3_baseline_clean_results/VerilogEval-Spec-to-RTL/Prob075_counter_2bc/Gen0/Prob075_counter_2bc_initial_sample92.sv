module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else if (train_valid) begin
        if (train_taken) begin
            if (state == 2'b11) begin
                state <= 2'b11; // saturation at maximum value
            end else begin
                state <= state + 1'b1;
            end
        end else begin
            if (state == 2'b00) begin
                state <= 2'b00; // saturation at minimum value
            end else begin
                state <= state - 1'b1;
            end
        end
    end else begin
        // No change when not training
        state <= state;
    end
end

endmodule