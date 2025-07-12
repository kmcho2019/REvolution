module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // Stores last 3 samples: [2]=oldest, [0]=newest

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new value
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Detect 010 pattern (shift_reg[2]=0, shift_reg[1]=1, shift_reg[0]=0)
        data_out <= (shift_reg[2:0] == 3'b010);
    end
end

endmodule