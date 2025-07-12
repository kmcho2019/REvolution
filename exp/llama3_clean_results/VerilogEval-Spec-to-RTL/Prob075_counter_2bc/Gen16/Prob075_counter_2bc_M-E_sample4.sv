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
        state_reg <= 2'b01;
    end else begin
        case (state_reg)
            2'b00: begin
                if (train_valid && train_taken) begin
                    state_reg <= 2'b01;
                end
            end
            2'b01: begin
                if (train_valid && train_taken) begin
                    state_reg <= 2'b11;
                end else if (train_valid && ~train_taken) begin
                    state_reg <= 2'b00;
                end
            end
            2'b11: begin
                if (train_valid && ~train_taken) begin
                    state_reg <= 2'b01;
                end
            end
        endcase
    end
end

assign state = state_reg;

endmodule