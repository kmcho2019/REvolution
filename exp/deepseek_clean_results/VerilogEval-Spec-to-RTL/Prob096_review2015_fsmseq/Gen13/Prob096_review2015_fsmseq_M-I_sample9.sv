module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    reg found;
    wire pattern_match;

    // First stage comparison (shift_reg[2:0] == 3'b110)
    assign pattern_match = (shift_reg[2:0] == 3'b110);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
        end else if (!found) begin
            // Clock gating: only shift when not found
            shift_reg <= {shift_reg[2:0], data};
            // Second stage comparison (AND with new data bit)
            found <= pattern_match && (data == 1'b1);
        end
    end

    assign start_shifting = found;

endmodule