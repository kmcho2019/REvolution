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

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: if (in) state <= 1; else state <= 0;
            1: if (in) state <= 2; else state <= 0;
            2: if (in) state <= 3; else state <= 0;
            3: if (in) state <= 4; else state <= 0;
            4: if (in) state <= 5; else state <= 0;
            5: if (in) state <= 6; else state <= 0;
            6: if (in) state <= 7; else state <= 1; // potential flag or discard
            7: if (in) state <= 7; else state <= 0; // error
            default: state <= 0;
        endcase

        disc_reg <= (state == 7) ? 0 : ((state == 6) && !in) ? 1 : 0;
        flag_reg <= (state == 7) ? 0 : ((state == 6) && in) ? 1 : 0;
        err_reg <= (state >= 7) ? 1 : 0;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule