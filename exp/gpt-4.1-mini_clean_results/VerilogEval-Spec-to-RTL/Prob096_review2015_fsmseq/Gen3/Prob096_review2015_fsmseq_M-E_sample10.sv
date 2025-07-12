module TopModule (
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
            // Shift in new data bit
            shift_reg <= {shift_reg[2:0], data};

            // Latch start_shifting once sequence 1101 detected
            if (!start_shifting && (shift_reg == 4'b1101))
                start_shifting <= 1'b1;
        end
    end

endmodule