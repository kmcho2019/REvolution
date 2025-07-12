module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] shift_reg;  // Stores last 3 bits

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
        end else if (!shift_reg[2]) begin  // Stop shifting after detection
            shift_reg <= {shift_reg[1:0], data};
        end
    end

    // Detection occurs when:
    // shift_reg == 3'b110 (previous 3 bits)
    // AND current data == 1'b1
    assign start_shifting = (shift_reg == 3'b110) && data;

endmodule