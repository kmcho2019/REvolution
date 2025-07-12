module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

reg [3:0] current_sequence;
reg       sequence_detected_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_sequence <= 4'b0000;
        sequence_detected_reg <= 1'b0;
    end else begin
        current_sequence <= {current_sequence[2:0], data_in};
        if (current_sequence == 4'b1001) begin
            sequence_detected_reg <= 1'b1;
        end else begin
            sequence_detected_reg <= 1'b0;
        end
    end
end

assign sequence_detected = sequence_detected_reg;

endmodule