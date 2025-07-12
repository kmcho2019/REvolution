module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg;
wire sequence_detected_next;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        shift_reg <= {shift_reg[2:0], data_in};
        sequence_detected <= sequence_detected_next;
    end
end

// Pattern matching logic
assign sequence_detected_next = shift_reg[3] & ~shift_reg[2] & ~shift_reg[1] & shift_reg[0];

endmodule