module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg;
wire clk_enable;
reg [1:0] idle_counter;

// Clock gating control
assign clk_enable = (|shift_reg[2:0]) | data_in | (idle_counter != 2'b11);

// Shift register with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        idle_counter <= 2'b0;
    end
    else if (clk_enable) begin
        shift_reg <= {shift_reg[2:0], data_in};
        idle_counter <= (data_in) ? 2'b0 : (idle_counter + 1'b1);
    end
end

// Registered output for better timing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sequence_detected <= 1'b0;
    else
        sequence_detected <= (shift_reg == 4'b1001);
end

endmodule