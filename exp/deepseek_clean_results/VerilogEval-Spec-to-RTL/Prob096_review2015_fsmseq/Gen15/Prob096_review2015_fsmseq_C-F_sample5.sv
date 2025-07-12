module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] shift_reg;  // Stores last 3 bits
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
            found <= 1'b0;
        end else if (!found) begin
            shift_reg <= {shift_reg[1:0], data};
            // Efficient parallel comparison:
            // Checks if last 2 bits are 10 and current bit is 1 (for 101)
            // And previous bit (shift_reg[2]) is 1 (for 1101)
            found <= (shift_reg[1:0] == 2'b10) && (data == 1'b1) && (shift_reg[2] == 1'b1);
        end
    end

    assign start_shifting = found;

endmodule