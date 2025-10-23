module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] shift_reg;  // Stores last 3 bits
    reg found;
    wire sequence_detected;

    // Parallel comparison for sequence '1101'
    assign sequence_detected = (shift_reg == 3'b110) & (data == 1'b1);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
            found <= 1'b0;
        end else if (!found) begin
            shift_reg <= {shift_reg[1:0], data};
            found <= sequence_detected;
        end
    end

    assign start_shifting = found;

endmodule