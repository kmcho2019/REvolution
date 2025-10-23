module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [3:0] count; // Counter for consecutive ones
reg disc_reg, flag_reg, err_reg;
reg prev_in; // Register to track the previous input

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        prev_in <= 0;
    end else begin
        // Update previous input
        prev_in <= in;

        // Update counter and outputs
        if (in) begin
            count <= count + 1;
        end else if (prev_in == 1) begin // If previous input was 1 and current is 0
            if (count == 5) begin // 5 consecutive ones followed by a zero
                disc_reg <= 1;
            end else if (count == 6) begin // Exactly 6 ones followed by a zero (flag condition)
                flag_reg <= 1;
            end else if (count >= 7) begin // 7 or more ones followed by a zero (error condition)
                err_reg <= 1;
            end
            count <= 0; // Reset counter on zero
        end else begin
            count <= 0; // Reset counter if not consecutive ones
        end

        // Clear outputs unless a condition is met
        if (!(count == 5 && !in) && !prev_in) begin
            disc_reg <= 0;
        end
        if (!(count == 6 && !in) && !prev_in) begin
            flag_reg <= 0;
        end
        if (!(count >= 7 && !in) && !prev_in) begin
            err_reg <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule