module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [6:0] shift_reg;
    reg disc_reg, flag_reg, err_reg;

    // Shift register to track last 7 bits
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
        end else begin
            shift_reg <= {shift_reg[5:0], in};
        end
    end

    // Output registration
    always @(posedge clk) begin
        if (reset) begin
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            // Default outputs
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;

            // Pattern matching
            if (shift_reg == 7'b0111110) begin
                disc_reg <= 1;
            end
            if (shift_reg == 7'b01111110) begin
                flag_reg <= 1;
            end
            if (shift_reg[6:0] == 7'b01111111) begin
                err_reg <= 1;
            end
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule