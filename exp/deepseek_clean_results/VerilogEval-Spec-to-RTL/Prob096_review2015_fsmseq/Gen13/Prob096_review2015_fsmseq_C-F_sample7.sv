module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    reg found;

    // Sequence detection happens when not already found
    wire sequence_detected = !found && (shift_reg[2:0] == 3'b110) && (data == 1'b1);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
        end else if (!found) begin
            shift_reg <= {shift_reg[2:0], data};
            found <= sequence_detected;
        end
    end

    assign start_shifting = found;

endmodule