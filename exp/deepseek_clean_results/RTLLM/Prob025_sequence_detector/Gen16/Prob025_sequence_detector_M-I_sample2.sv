module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    input data_valid,  // New enable signal for power optimization
    output reg sequence_detected
);

reg [3:0] shift_reg;
wire detection;

// Clock gating for shift register when data_valid is low
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
    end
    else if (data_valid) begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

// Simplified pattern matching
assign detection = shift_reg[3] & ~shift_reg[2] & ~shift_reg[1] & shift_reg[0];

// Registered output for better timing and power
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sequence_detected <= 1'b0;
    end
    else begin
        sequence_detected <= detection;
    end
end

endmodule