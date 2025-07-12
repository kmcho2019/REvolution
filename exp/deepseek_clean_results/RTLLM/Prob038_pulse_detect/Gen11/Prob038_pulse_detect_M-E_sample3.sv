module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg;

// Shift register to track last 3 samples
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
    end
    else begin
        shift_reg <= {shift_reg[1:0], data_in};
    end
end

// Pulse detection logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 1'b0;
    end
    else begin
        // Detect pattern 0->1->0 in last three cycles
        data_out <= (shift_reg == 3'b010);
    end
end

endmodule