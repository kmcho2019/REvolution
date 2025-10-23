module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    input en,         // Added enable signal for power optimization
    output reg sequence_detected  // Registered output for timing improvement
);

reg [3:0] shift_reg;
wire pattern_match;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        sequence_detected <= 1'b0;
    end
    else if (en) begin  // Only update when enabled
        shift_reg <= {shift_reg[2:0], data_in};
        // Pipelined detection output
        sequence_detected <= shift_reg[3] & ~shift_reg[2] & ~shift_reg[1] & shift_reg[0];
    end
    else begin
        sequence_detected <= 1'b0;  // Clear detection when disabled
    end
end

endmodule