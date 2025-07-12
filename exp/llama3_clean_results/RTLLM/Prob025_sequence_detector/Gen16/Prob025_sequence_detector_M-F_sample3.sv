module sequence_detector(
    input clk,
    input rst_n, // Changed port name to match the testbench
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg; // 4-bit shift register

// Shift register logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {data_in, shift_reg[3:1]};
    end
end

// Comparator logic
assign sequence_detected = (shift_reg == 4'b1001);

endmodule