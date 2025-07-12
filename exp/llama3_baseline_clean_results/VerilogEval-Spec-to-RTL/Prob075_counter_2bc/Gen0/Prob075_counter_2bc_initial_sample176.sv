module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
reg [1:0] next_state;

always @(*) begin
    next_state = state_reg;
    if (train_valid) begin
        if (train_taken) begin
            if (state_reg == 2'b11) begin
                next_state = state_reg; // saturate at 3
            end else begin
                next_state = state_reg + 1'b1;
            end
        end else begin
            if (state_reg == 2'b00) begin
                next_state = state_reg; // saturate at 0
            end else begin
                next_state = state_reg - 1'b1;
            end
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // reset to 2'b01
    end else begin
        state_reg <= next_state;
    end
end

assign state = state_reg;

endmodule