module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits can represent 8 states (0 to 7)
wire disc_w, flag_w, err_w;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state 0 (S0)
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (in) state <= 1; // Move to S1 on '1'
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            1: begin // S1
                if (in) state <= 2; // Move to S2 on '1'
                else state <= 0; // Reset to S0 on '0'
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            2: begin // S2
                if (in) state <= 3; // Move to S3 on '1'
                else state <= 0; // Reset to S0 on '0'
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            3: begin // S3
                if (in) state <= 4; // Move to S4 on '1'
                else state <= 0; // Reset to S0 on '0'
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            4: begin // S4
                if (in) state <= 5; // Move to S5 on '1'
                else state <= 0; // Reset to S0 on '0'
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            5: begin // S5
                if (in) begin
                    state <= 6; // Move to S6 on '1'
                    disc <= 1; // Set disc signal
                end else state <= 0; // Reset to S0 on '0'
                flag <= 0;
                err <= 0;
            end
            6: begin // S6
                if (in) begin
                    state <= 7; // Move to ERR on '1' (7 or more '1's)
                    err <= 1; // Set err signal
                end else begin
                    state <= 0; // Reset to S0 on '0'
                    flag <= 1; // Set flag signal
                end
                disc <= 0;
                err <= (state == 7);
            end
            7: begin // ERR
                if (~in) state <= 0; // Reset to S0 on '0'
                disc <= 0;
                flag <= 0;
                err <= 1; // Keep err signal high
            end
            default: state <= 0;
        endcase
    end
end

assign disc = (state == 5 && in);
assign flag = (state == 6 && ~in);
assign err = (state == 7);

endmodule