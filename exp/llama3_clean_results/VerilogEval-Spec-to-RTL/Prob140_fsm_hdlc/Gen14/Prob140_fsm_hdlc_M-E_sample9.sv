module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] count; // Counter to count consecutive ones
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        if (in) begin
            count <= count + 1;
            if (count == 5) begin
                // Check next input for "01111110" or "01111111"
                if (count == 5 && in) begin
                    // Do nothing, wait for next cycle
                end
            end else if (count == 6) begin
                // Check next input for "01111110"
                if (in) begin
                    err_reg <= 1; // More than 6 consecutive ones
                end else begin
                    flag_reg <= 1; // Flag sequence "01111110"
                    count <= 0; // Reset counter
                end
            end else if (count > 6) begin
                err_reg <= 1; // More than 6 consecutive ones
            end
        end else begin
            // Reset counter when 0 is encountered
            if (count == 5) begin
                disc_reg <= 1; // Discard bit
            end
            count <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule