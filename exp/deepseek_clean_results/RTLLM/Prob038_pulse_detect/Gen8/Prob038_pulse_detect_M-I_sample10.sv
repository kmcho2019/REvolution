module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg;
reg last_data;
wire data_changed = (data_in != last_data);
wire clk_enable = data_changed;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
        last_data <= 1'b0;
        data_out <= 1'b0;
    end else if (clk_enable) begin
        shift_reg <= {shift_reg[1:0], data_in};
        last_data <= data_in;
        // Registered output for better timing
        data_out <= (shift_reg[1:0] == 2'b10) && (data_in == 1'b0);
    end else begin
        data_out <= 1'b0;  // Clear output when no transition
    end
end

endmodule