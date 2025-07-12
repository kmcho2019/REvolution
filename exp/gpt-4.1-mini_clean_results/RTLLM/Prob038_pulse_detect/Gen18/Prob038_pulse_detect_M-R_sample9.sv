module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    reg [2:0] shift_reg;

    // Shift in data_in each clock cycle; reset clears register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 3'b000;
        else
            shift_reg <= {shift_reg[1:0], data_in};
    end

    // Detect pulse pattern 0->1->0 in last three samples: shift_reg == 3'b010
    assign data_out = (shift_reg == 3'b010) ? 1'b1 : 1'b0;

endmodule