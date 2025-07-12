module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= 2'b01; // Initialize to TAKEN state
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                state_reg <= (state_reg == 2'b11) ? 2'b11 : state_reg + 1;
            end else begin
                state_reg <= (state_reg == 2'b00) ? 2'b00 : state_reg - 1;
            end
        end else begin
            // No change when train_valid is 0
        end
    end
end

assign state = state_reg;

endmodule