module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 0: Idle, 1: One, 2: Two, 3: Three, 4: Four, 5: Five, 6: Flag, 7: Error
reg disc_reg, flag_reg, err_reg;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to Idle state
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (in) state <= 1;
                else state <= 0;
            end
            1: begin // One
                if (in) state <= 2;
                else state <= 0;
            end
            2: begin // Two
                if (in) state <= 3;
                else state <= 0;
            end
            3: begin // Three
                if (in) state <= 4;
                else state <= 0;
            end
            4: begin // Four
                if (in) state <= 5;
                else state <= 0;
            end
            5: begin // Five
                if (in) state <= 7; // Error
                else state <= 0;
            end
            7: begin // Error
                if (in) state <= 7;
                else state <= 0;
                err_reg <= 1;
            end
            default: state <= 0;
        endcase

        if (state == 6) begin // Flag
            flag_reg <= 1;
            state <= 0;
        end

        if (state == 5 && !in) begin // Discard
            disc_reg <= 1;
            state <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

always @ (posedge clk) begin
    disc_reg <= 0;
    flag_reg <= 0;
    err_reg <= 0;
end

endmodule