module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 8 states: 0 to 7
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin
                if (in) state <= 1;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            1: begin
                if (in) state <= 2;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            2: begin
                if (in) state <= 3;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            3: begin
                if (in) state <= 4;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            4: begin
                if (in) state <= 5;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            5: begin
                if (in) state <= 6;
                else state <= 0;
                disc_reg <= 1; // discard bit
                flag_reg <= 0;
                err_reg <= 0;
            end
            6: begin
                if (in) state <= 7; // error state
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 1; // flag detected
                err_reg <= 0;
            end
            7: begin
                if (in) state <= 7; // stay in error state
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 1; // error detected
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule