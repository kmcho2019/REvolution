module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_reg;

    // shift_ena is OR of all shift register bits
    assign shift_ena = |shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b1111;  // Initialize to all 1s
        end else begin
            // Shift right with 0 input
            shift_reg <= {1'b0, shift_reg[3:1]};
        end
    end

endmodule