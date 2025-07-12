module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    // input enable,  // Optional enable signal for power savings
    output reg sequence_detected
);

reg [3:0] shift_reg;
wire pattern_match;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // if (enable) begin  // Uncomment if using enable signal
            shift_reg <= {shift_reg[2:0], data_in};
        // end
        sequence_detected <= pattern_match;
    end
end

// Pattern matching remains simple but now registered
assign pattern_match = shift_reg[3] & ~shift_reg[2] & ~shift_reg[1] & shift_reg[0];

endmodule