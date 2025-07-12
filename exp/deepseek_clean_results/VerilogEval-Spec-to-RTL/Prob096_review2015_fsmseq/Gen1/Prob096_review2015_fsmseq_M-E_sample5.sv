module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            // Shift in new data and check for pattern
            shift_reg <= {shift_reg[2:0], data};
            start_shifting <= (shift_reg[2:0] == 3'b110) && (data == 1'b1);
        end
        // Once start_shifting is set, it remains high until reset
    end

endmodule