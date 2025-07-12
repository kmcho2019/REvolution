module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg disc_reg;
reg flag_reg;
reg err_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case(state)
            0: begin // S0: Reset or previous input was 0
                if(in) state <= 1;
            end
            1: begin // S1: Previous input was 1
                if(in) state <= 2;
                else state <= 0;
            end
            2: begin // S2: Previous two inputs were 1
                if(in) state <= 3;
                else state <= 0;
            end
            3: begin // S3: Previous three inputs were 1
                if(in) state <= 4;
                else state <= 0;
            end
            4: begin // S4: Previous four inputs were 1
                if(in) state <= 5;
                else state <= 0;
            end
            5: begin // S5: Previous five inputs were 1 (potential discard or flag)
                if(in) state <= 6;
                else begin
                    state <= 0;
                    disc_reg <= 1;
                end
            end
            6: begin // S6: Previous six inputs were 1 (potential flag)
                if(in) state <= 7;
                else begin
                    state <= 0;
                    flag_reg <= 1;
                end
            end
            7: begin // S7: Previous seven or more inputs were 1 (error)
                if(in) state <= 7;
                else state <= 0;
                err_reg <= 1;
            end
        endcase
    end
end

always @(posedge clk) begin
    disc <= disc_reg;
    flag <= flag_reg;
    err <= err_reg;
    disc_reg <= 0;
    flag_reg <= 0;
    err_reg <= 0;
end

endmodule