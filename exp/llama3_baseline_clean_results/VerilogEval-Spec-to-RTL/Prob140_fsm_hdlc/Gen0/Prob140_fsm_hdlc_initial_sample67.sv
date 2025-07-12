module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 0: seen 0, 1: seen 1, 2-4: seen 2-4 ones, 5-6: seen 5-6 ones
reg disc_reg, flag_reg, err_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // Seen 0 so far
                if (in) begin
                    state <= 1; // Transition to seen 1
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end else begin
                    state <= 0; // Stay in seen 0
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            1: begin // Seen 1 so far
                if (in) begin
                    state <= 2; // Transition to seen 2
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end else begin
                    state <= 0; // Reset to seen 0
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            2: begin // Seen 2 ones so far
                if (in) begin
                    state <= 3; // Transition to seen 3
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end else begin
                    state <= 0; // Reset to seen 0
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            3: begin // Seen 3 ones so far
                if (in) begin
                    state <= 4; // Transition to seen 4
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end else begin
                    state <= 0; // Reset to seen 0
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            4: begin // Seen 4 ones so far
                if (in) begin
                    state <= 5; // Transition to seen 5
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end else begin
                    state <= 0; // Reset to seen 0
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            5: begin // Seen 5 ones so far
                if (in) begin
                    state <= 6; // Transition to seen 6
                    disc_reg <= 1; // Discard this bit
                    flag_reg <= 0;
                    err_reg <= 0;
                end else begin
                    state <= 0; // Reset to seen 0
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            6: begin // Seen 6 ones so far
                if (in) begin
                    state <= 6; // Stay in seen 6
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 1; // Error, 7 or more consecutive 1s
                end else begin
                    state <= 0; // Reset to seen 0
                    disc_reg <= 0;
                    flag_reg <= 1; // Signal the start/end of frame
                    err_reg <= 0;
                end
            end
            default: begin
                state <= 0; // Reset to seen 0
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