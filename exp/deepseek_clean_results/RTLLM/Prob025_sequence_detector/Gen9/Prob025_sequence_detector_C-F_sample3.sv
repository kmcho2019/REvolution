module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] shift_reg;  // Stores last 3 bits
reg detected_next;

// Shift register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        sequence_detected <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[1:0], data_in};
        sequence_detected <= detected_next;
    end
end

// Detection logic (1001 pattern)
always @(*) begin
    detected_next = 1'b0;
    // Pattern matches when we have 100 in shift_reg and current input is 1
    if (shift_reg[2] & ~shift_reg[1] & ~shift_reg[0] & data_in) begin
        detected_next = 1'b1;
    end
end

endmodule