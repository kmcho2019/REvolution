module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // state variable
reg disc_reg, flag_reg, err_reg; // output registers

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin
                if (in) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin
                if (in) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin
                if (in) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
            end
            3: begin
                if (in) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
            end
            4: begin
                if (in) begin
                    state <= 5;
                end else begin
                    state <= 0;
                end
            end
            5: begin
                if (in) begin
                    state <= 6; // flag detected
                    disc_reg <= 0;
                    flag_reg <= 1;
                    err_reg <= 0;
                end else begin
                    state <= 0;
                    disc_reg <= 1; // discard
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            6: begin
                if (in) begin
                    state <= 7; // error state
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 1;
                end else begin
                    state <= 0;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
            end
            7: begin
                if (in) begin
                    state <= 7; // stay in error state
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 1;
                end else begin
                    state <= 0;
                    disc_reg <= 0;
                    flag_reg <= 0;
                    err_reg <= 0;
                end
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