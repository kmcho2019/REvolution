module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // States: 0 (S0), 1 (S1), 2 (S2), 3 (S3), 4 (S4), 5 (S5), 6 (S6), 7 (S7)
reg disc_reg, flag_reg, err_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (in) state <= 1;
                else state <= 0;
            end
            1: begin // S1
                if (in) state <= 2;
                else state <= 0;
            end
            2: begin // S2
                if (in) state <= 3;
                else state <= 0;
            end
            3: begin // S3
                if (in) state <= 4;
                else state <= 0;
            end
            4: begin // S4
                if (in) state <= 5;
                else state <= 0;
            end
            5: begin // S5
                if (in) state <= 6;
                else state <= 0;
            end
            6: begin // S6
                if (in) state <= 7;
                else state <= 0;
                flag_reg <= 1; // Flag detected
                if ($past(state) == 5) disc_reg <= 1; // Previous state was S5, discard
            end
            7: begin // S7
                if (in) state <= 7;
                else state <= 0;
                err_reg <= 1; // Error detected
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

always @(posedge clk) begin
    disc_reg <= 0;
    flag_reg <= 0;
    err_reg <= 0;
end

endmodule