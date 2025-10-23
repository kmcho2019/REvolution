module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // Stores last 3 samples: [2]=oldest, [0]=newest
wire pulse_detected;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new value
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Register the detection result for perfect timing
        data_out <= pulse_detected;
    end
end

// Combinational detection of 010 pattern
assign pulse_detected = (shift_reg[2:0] == 3'b010);

endmodule