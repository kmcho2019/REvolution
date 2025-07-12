module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [1:0] state; // 0: 0 1s, 1: 1 1, 2: 2-5 1s, 3: 6 or more 1s
reg disc_reg;
reg flag_reg;
reg err_reg;

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
                end else begin
                    state <= 0;
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
                    if (state == 2) begin
                        state <= 2; // still 2-5 1s
                    end else if (state == 2) begin // this is not possible, just for 2 state value
                        state <= 2;
                    end
                    if (state == 2 && in == 1'b1) begin
                        disc_reg <= 1;
                        flag_reg <= 0;
                        err_reg <= 0;
                    end
                end else begin
                    state <= 0;
                end
                if (state == 2 && in == 1'b0) begin
                    flag_reg <= 0;
                    err_reg <= 0;
                end
                if (in) begin
                    if (state == 2) begin
                        state <= 3;
                    end else begin
                        state <= 3;
                    end
                end
            end
            3: begin
                if (in) begin
                    state <= 3;
                    err_reg <= 1;
                    flag_reg <= 0;
                    disc_reg <= 0;
                end else begin
                    state <= 0;
                    flag_reg <= 1;
                    err_reg <= 0;
                    disc_reg <= 0;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule