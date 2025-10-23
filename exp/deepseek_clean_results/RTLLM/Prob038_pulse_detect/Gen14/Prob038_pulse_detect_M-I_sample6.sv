module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] shift_reg;  // Stores last two data_in values
reg last_data_in;     // For clock gating detection
wire shift_enable;    // Clock gating control

// Clock gating control - only shift when input changes
assign shift_enable = (data_in != last_data_in);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b00;
        data_out <= 1'b0;
        last_data_in <= 1'b0;
    end else begin
        last_data_in <= data_in;
        
        // Shift register with clock gating
        if (shift_enable) begin
            shift_reg <= {shift_reg[0], data_in};
        end
        
        // Detect 0->1->0 pattern (shift_reg == 01 and current input == 0)
        data_out <= shift_reg[1] & ~shift_reg[0] & ~data_in;
    end
end

endmodule