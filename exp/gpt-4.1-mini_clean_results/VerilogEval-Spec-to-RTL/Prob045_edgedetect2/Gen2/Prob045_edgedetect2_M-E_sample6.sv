module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] shift_reg_0;
    reg [7:0] shift_reg_1;

    always @(posedge clk) begin
        // Shift inputs through two registers to hold consecutive cycles
        shift_reg_1 <= shift_reg_0;
        shift_reg_0 <= in;

        // Detect edges by XORing the two stored inputs from previous cycles
        anyedge <= shift_reg_0 ^ shift_reg_1;
    end

endmodule