module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // 3 bits to count consecutive ones
reg [1:0] state; // 2 bits to represent 4 states
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (state)
            0: begin // IDLE state
                if (in) begin
                    count <= 1;
                    state <= 1;
                end else begin
                    count <= 0;
                    state <= 0;
                end
            end
            1: begin // COUNTING state
                if (in) begin
                    count <= count + 1;
                    if (count == 5) state <= 2;
                    else state <= 1;
                end else begin
                    if (count == 5) begin
                        disc_reg <= 1;
                        state <= 0;
                    end else begin
                        state <= 0;
                    end
                end
            end
            2: begin // SIX_ONES state
                if (in) begin
                    err_reg <= 1;
                    state <= 3;
                end else begin
                    flag_reg <= 1;
                    state <= 0;
                end
            end
            3: begin // SEVEN_ONES state
                if (~in) state <= 0;
                else begin
                    err_reg <= 1;
                    state <= 3;
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule