module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

always @(*) begin
    case (state_reg)
        2'b00: begin
            if (train_valid && train_taken) state_reg = 2'b01;
            else if (train_valid && !train_taken) state_reg = 2'b00;
        end
        2'b01: begin
            if (train_valid && train_taken) state_reg = 2'b10;
            else if (train_valid && !train_taken) state_reg = 2'b00;
        end
        2'b10: begin
            if (train_valid && train_taken) state_reg = 2'b11;
            else if (train_valid && !train_taken) state_reg = 2'b01;
        end
        2'b11: begin
            if (train_valid && train_taken) state_reg = 2'b11;
            else if (train_valid && !train_taken) state_reg = 2'b10;
        end
        default: state_reg = 2'b01;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else begin
        if (train_valid) begin
            case (state_reg)
                2'b00: begin
                    if (train_taken) state_reg <= 2'b01;
                    else state_reg <= 2'b00;
                end
                2'b01: begin
                    if (train_taken) state_reg <= 2'b10;
                    else state_reg <= 2'b00;
                end
                2'b10: begin
                    if (train_taken) state_reg <= 2'b11;
                    else state_reg <= 2'b01;
                end
                2'b11: begin
                    if (train_taken) state_reg <= 2'b11;
                    else state_reg <= 2'b10;
                end
                default: state_reg <= 2'b01;
            endcase
        end else begin
            state_reg <= state_reg;
        end
    end
end

assign state = state_reg;

endmodule