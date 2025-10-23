module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    reg [2:0] shift_reg;

    // Shift data_in into shift_reg on each clock cycle
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            shift_reg <= 3'b000;
        else
            shift_reg <= {shift_reg[1:0], data_in};
    end

    // Detect pulse pattern: 0 -> 1 -> 0 in last 3 bits (shift_reg)
    // shift_reg[2] = oldest, shift_reg[0] = newest
    assign data_out = (shift_reg == 3'b010);

endmodule