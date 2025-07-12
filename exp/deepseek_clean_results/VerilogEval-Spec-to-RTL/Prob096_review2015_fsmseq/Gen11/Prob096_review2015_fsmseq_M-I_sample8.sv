module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [3:0] shift_reg;
    reg found;
    wire first_half_match;
    wire second_half_match;

    // Split comparison into two 2-bit checks
    assign first_half_match = (shift_reg[3:2] == 2'b11);
    assign second_half_match = (shift_reg[1:0] == 2'b01);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
            found <= 1'b0;
        end else if (!found) begin
            shift_reg <= {shift_reg[2:0], data};
            // Combine the two 2-bit comparisons
            found <= first_half_match && (shift_reg[1:0] == 2'b10) && data;
        end
    end

    assign start_shifting = found;

endmodule