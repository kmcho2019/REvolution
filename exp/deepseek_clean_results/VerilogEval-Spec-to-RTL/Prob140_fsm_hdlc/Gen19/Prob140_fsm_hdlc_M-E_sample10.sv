module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};

            // Pattern matching outputs
            disc <= (shift_reg[6:1] == 6'b011111) && !in;
            flag <= (shift_reg == 7'b0111110);
            err <= (shift_reg == 7'b0111111) && in;
        end
    end

endmodule