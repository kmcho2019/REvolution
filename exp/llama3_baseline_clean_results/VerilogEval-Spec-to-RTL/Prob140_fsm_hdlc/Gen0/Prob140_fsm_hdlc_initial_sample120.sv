module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 0 - Idle, 1 - S1, 2 - S2, 3 - S3, 4 - S4, 5 - S5, 6 - S6, 7 - Err
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Idle
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end
    else begin
        case (state)
            0: begin // Idle
                if (in) state <= 1; // S1
                else state <= 0; // Idle
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            1: begin // S1
                if (in) state <= 2; // S2
                else state <= 0; // Idle
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            2: begin // S2
                if (in) state <= 3; // S3
                else state <= 0; // Idle
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            3: begin // S3
                if (in) state <= 4; // S4
                else state <= 0; // Idle
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            4: begin // S4
                if (in) state <= 5; // S5
                else state <= 0; // Idle
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            5: begin // S5
                if (in) state <= 6; // S6
                else begin
                    state <= 0; // Idle
                    disc_reg <= 1; // discard
                end
                flag_reg <= 0;
                err_reg <= 0;
            end
            6: begin // S6
                if (in) state <= 7; // Err
                else begin
                    state <= 0; // Idle
                    flag_reg <= 1; // flag
                end
                disc_reg <= 0;
                err_reg <= 0;
            end
            7: begin // Err
                if (!in) state <= 0; // Idle
                flag_reg <= 0;
                disc_reg <= 0;
                err_reg <= 1; // error
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule