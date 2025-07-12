module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;

    // Shift register update
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            shift_reg <= {shift_reg[5:0], in};

            // Pattern detection (combinational)
            disc <= (shift_reg == 7'b0111110) && !in;
            flag <= (shift_reg == 7'b0111111) && !in;
            err <= &shift_reg;  // All bits are 1
        end
    end

endmodule