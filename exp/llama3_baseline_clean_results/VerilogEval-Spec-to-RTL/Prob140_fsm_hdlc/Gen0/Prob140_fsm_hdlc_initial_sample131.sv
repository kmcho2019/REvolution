module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states (S0-S7)
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to S0
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (in) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            1: begin // S1
                if (in) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            2: begin // S2
                if (in) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            3: begin // S3
                if (in) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            4: begin // S4
                if (in) begin
                    state <= 5;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            5: begin // S5
                if (in) begin
                    state <= 6;
                    disc_reg <= 1; // Set disc
                end else begin
                    state <= 0;
                end
                flag_reg <= 0;
                err_reg <= 0;
            end
            6: begin // S6
                if (in) begin
                    state <= 7;
                    err_reg <= 1; // Set error
                end else begin
                    state <= 0;
                    flag_reg <= 1; // Set flag
                end
                disc_reg <= 0;
            end
            7: begin // S7
                if (in) begin
                    state <= 7;
                    err_reg <= 1; // Keep error set
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
            end
            default: begin
                state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule