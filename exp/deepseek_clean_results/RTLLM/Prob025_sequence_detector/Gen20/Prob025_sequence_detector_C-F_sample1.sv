module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] shift_reg;  // Stores last 3 bits
wire [3:0] current_pattern;

// Transparent shift operation
assign current_pattern = {shift_reg, data_in};

// Shift register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        sequence_detected <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[1:0], data_in};
        // Registered output for clean timing
        sequence_detected <= (current_pattern == 4'b1001);
    end
end

endmodule