module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] shift_reg;  // Stores last 7 bits of input

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[5:0], in};

            // Pattern matching (all checked in parallel)
            disc <= (shift_reg[5:0] == 6'b111110) && !in;  // 5 1s followed by 0
            flag <= (shift_reg == 7'b0111110);              // 6 1s between 0s
            err <= &shift_reg;                              // 7 or more 1s
        end
    end

endmodule