module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent states S0 to S6 and SERR
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state to S0
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // S0
                if (in) state <= 1;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            1: begin // S1
                if (in) state <= 2;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            2: begin // S2
                if (in) state <= 3;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            3: begin // S3
                if (in) state <= 4;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            4: begin // S4
                if (in) state <= 5;
                else state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 0;
            end
            5: begin // S5
                if (in) state <= 6;
                else state <= 0;
                disc_reg <= 1; // Signal to discard a bit
                flag_reg <= 0;
                err_reg <= 0;
            end
            6: begin // S6
                if (in) state <= 7; // Go to error state
                else begin 
                    state <= 0;
                    disc_reg <= 0;
                    flag_reg <= 1; // Signal the beginning/end of a frame
                    err_reg <= 0;
                end
            end
            default: begin // SERR
                if (~in) state <= 0;
                disc_reg <= 0;
                flag_reg <= 0;
                err_reg <= 1; // Signal an error
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule