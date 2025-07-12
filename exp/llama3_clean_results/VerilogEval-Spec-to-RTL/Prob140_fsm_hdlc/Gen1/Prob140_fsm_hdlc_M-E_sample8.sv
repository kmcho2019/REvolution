module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] counter; // 3-bit counter
reg prev_bit; // Previous bit flag
reg disc_reg, flag_reg, err_reg; // Output registers

always @(posedge clk) begin
    if (reset) begin
        counter <= 0; // Reset counter
        prev_bit <= 0; // Reset previous bit flag
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        if (in) begin
            counter <= counter + 1; // Increment counter
            prev_bit <= 1; // Set previous bit flag
        end else begin
            counter <= 0; // Reset counter
            prev_bit <= 0; // Reset previous bit flag
        end

        if (counter == 5) begin
            disc_reg <= 1; // Assert disc signal
        end else begin
            disc_reg <= 0;
        end

        if (counter == 6 && ~in) begin
            flag_reg <= 1; // Assert flag signal
        end else begin
            flag_reg <= 0;
        end

        if (counter >= 7) begin
            err_reg <= 1; // Assert err signal
        end else begin
            err_reg <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule