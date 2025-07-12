module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // S0, S1, S2, S3
reg [1:0] nextState;
reg disc_reg, flag_reg, err_reg;

always @(*) begin
    case(state)
        2'b00: begin // S0
            if (in) begin
                nextState = 2'b01;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 2'b00;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        2'b01: begin // S1
            if (in) begin
                nextState = 2'b10;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 2'b00;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        2'b10: begin // S2
            if (in) begin
                if (~in) begin // next '0' after 5 '1's
                    nextState = 2'b00;
                    disc_reg = 1'b1;
                    flag_reg = 1'b0;
                    err_reg = 1'b0;
                end else if (~in && state == 2'b11) begin // flag condition
                    nextState = 2'b00;
                    disc_reg = 1'b0;
                    flag_reg = 1'b1;
                    err_reg = 1'b0;
                end else begin // 6 or more '1's
                    nextState = 2'b11;
                    disc_reg = 1'b0;
                    flag_reg = 1'b0;
                    err_reg = 1'b1;
                end
            end else begin
                nextState = 2'b00;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end
        end
        2'b11: begin // S3 (error state)
            if (~in) begin
                nextState = 2'b00;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b0;
            end else begin
                nextState = 2'b11;
                disc_reg = 1'b0;
                flag_reg = 1'b0;
                err_reg = 1'b1;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

endmodule