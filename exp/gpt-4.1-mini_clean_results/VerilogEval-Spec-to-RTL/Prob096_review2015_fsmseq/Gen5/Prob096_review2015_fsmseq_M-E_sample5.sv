module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            start_shifting <= 1'b0;
        end else begin
            // Shift in the new bit from data
            shift_reg <= {shift_reg[2:0], data};
            // Compare the 4-bit window to 1101
            if (shift_reg == 4'b1101)
                start_shifting <= 1'b1;
            else if (start_shifting)
                start_shifting <= 1'b1; // latch start_shifting forever after detected
        end
    end

endmodule