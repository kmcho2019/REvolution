module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // States: 0 to 7
reg disc_reg, flag_reg, err_reg; // Registers for output signals

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        case (state)
            0: begin // State 0
                if (in) state <= 1; // Counting starts
                else state <= 0;
            end
            1: begin // State 1
                if (in) state <= 2;
                else state <= 0;
            end
            2: begin // State 2
                if (in) state <= 3;
                else state <= 0;
            end
            3: begin // State 3
                if (in) state <= 4;
                else state <= 0;
            end
            4: begin // State 4
                if (in) state <= 5;
                else state <= 0;
            end
            5: begin // State 5
                if (in) state <= 6; // Potential flag or discard sequence
                else state <= 0;
            end
            6: begin // State 6
                if (in) state <= 7; // Error sequence detected
                else begin
                    state <= 0;
                    flag_reg <= 1; // Assert flag for one cycle
                end
            end
            7: begin // State 7
                if (in) state <= 7; // Continue error sequence
                else begin
                    state <= 0;
                    err_reg <= 1; // Assert error for one cycle
                end
            end
        endcase
        // Detecting the discard sequence (0111110)
        if (state == 6 && ~in) disc_reg <= 1;
        // Resetting the output registers
        if (state != 6 || in) disc_reg <= 0;
        if (state != 6 || in) flag_reg <= 0;
        if (state != 7) err_reg <= 0;
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule