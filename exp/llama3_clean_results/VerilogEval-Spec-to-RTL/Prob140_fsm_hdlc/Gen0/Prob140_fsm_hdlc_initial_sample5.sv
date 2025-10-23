module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // counter for consecutive 1s
reg disc_reg, flag_reg, err_reg; // registers for output signals

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin
                if (in) begin
                    state <= 1;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            1: begin
                if (in) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            2: begin
                if (in) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            3: begin
                if (in) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            4: begin
                if (in) begin
                    state <= 5;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            5: begin
                if (in) begin
                    state <= 6;
                    disc_reg <= 1; // assert disc signal
                end else begin
                    state <= 0;
                    flag_reg <= 1; // assert flag signal
                end
                err_reg <= 0;
            end
            6: begin
                if (in) begin
                    state <= 7;
                    err_reg <= 1; // assert err signal
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
            end
            7: begin
                if (in) begin
                    state <= 7;
                end else begin
                    state <= 0;
                end
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 1; // keep err signal asserted
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