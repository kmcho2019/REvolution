module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [1:0] state;
reg [2:0] ones_count;
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        ones_count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin
                if (in) begin
                    ones_count <= ones_count + 1;
                    if (ones_count == 5) begin
                        state <= 1;
                    end
                end else begin
                    ones_count <= 0;
                end
            end
            1: begin
                if (in) begin
                    ones_count <= ones_count + 1;
                    if (ones_count == 6) begin
                        flag_reg <= 1;
                        state <= 0;
                    end else if (ones_count > 6) begin
                        err_reg <= 1;
                        state <= 0;
                    end
                end else if (!in && ones_count == 5) begin
                    disc_reg <= 1;
                    state <= 0;
                end else begin
                    ones_count <= 0;
                    state <= 0;
                end
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