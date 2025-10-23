module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] counter; // Counter for consecutive ones
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        if (in) begin
            counter <= counter + 1;
            if (counter == 5) begin
                disc_reg <= (in == 0) ? 1 : 0; // Corrected condition for disc
            end else if (counter == 6) begin
                flag_reg <= 1;
            end else if (counter >= 7) begin
                err_reg <= 1;
            end
        end else begin
            counter <= 0;
        end
        // Update output registers based on current state and input
        if (counter == 6 && in == 0) begin
            flag_reg <= 1;
        end
        if (in == 0 && counter == 5) begin
            disc_reg <= 1;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule