module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [2:0] shift_reg;
reg data_out_reg;

// Shift register implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
        data_out_reg <= 1'b0;
    end
    else begin
        shift_reg <= {shift_reg[1:0], data_in};
        data_out_reg <= (shift_reg == 3'b010);
    end
end

// Direct output assignment
assign data_out = data_out_reg;

endmodule