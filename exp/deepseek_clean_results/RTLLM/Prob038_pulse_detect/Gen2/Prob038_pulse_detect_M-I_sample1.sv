module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] shift_reg;  // Stores last 2 samples
reg potential_pulse;   // Flag indicating we've seen 01

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b00;
        potential_pulse <= 0;
        data_out <= 0;
    end else begin
        // Shift in new data
        shift_reg <= {shift_reg[0], data_in};
        
        // Update potential pulse flag
        potential_pulse <= (shift_reg == 2'b01);
        
        // Check for pulse completion (only when we've seen 01 first)
        data_out <= potential_pulse && (data_in == 0);
    end
end

endmodule