module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [7:0] shift_reg; // 8-bit shift register
reg [2:0] count; // Counter for consecutive ones
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
        count <= 3'b0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        // Shift in the new bit
        shift_reg <= {shift_reg[6:0], in};

        // Update counter
        if (in) begin
            count <= count + 1;
        end else begin
            count <= 3'b0;
        end

        // Check for flag
        if (shift_reg == 8'b01111110) begin
            flag_reg <= 1;
        end else begin
            flag_reg <= 0;
        end

        // Check for error
        if (count >= 3'b111) begin // 7 or more consecutive ones
            err_reg <= 1;
        end else begin
            err_reg <= 0;
        end

        // Check for discard
        if (count == 3'b101 && ~in) begin // 5 consecutive ones followed by a zero
            disc_reg <= 1;
        end else begin
            disc_reg <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule