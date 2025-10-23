module TopModule (
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output [1:0]    state
);

reg [1:0] state_reg;
reg [1:0] state_next;

always @(*) begin
    if (train_valid) begin
        if (train_taken) begin
            if (state_reg == 2'b11) begin
                state_next = 2'b11;  // saturate at maximum value
            end else begin
                state_next = state_reg + 1;
            end
        end else begin
            if (state_reg == 2'b00) begin
                state_next = 2'b00;  // saturate at minimum value
            end else begin
                state_next = state_reg - 1;
            end
        end
    end else begin
        state_next = state_reg;  // hold the current value when not training
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01;  // reset to weakly not-taken
    end else begin
        state_reg <= state_next;
    end
end

assign state = state_reg;

endmodule