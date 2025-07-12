module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Phase registers - each represents a different starting point in the sequence
reg p0, p1, p2, p3;

// Next state logic for each phase
wire p0_next = data_in;        // Potential start of sequence (looking for '1')
wire p1_next = p0 & ~data_in;  // After '1', looking for '0'
wire p2_next = p1 & ~data_in;  // After '10', looking for '0'
wire p3_next = p2 & data_in;   // After '100', looking for '1'

// Register updates
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        p0 <= 1'b0;
        p1 <= 1'b0;
        p2 <= 1'b0;
        p3 <= 1'b0;
    end else begin
        p0 <= p0_next;
        p1 <= p1_next;
        p2 <= p2_next;
        p3 <= p3_next;
    end
end

// Detection occurs when p3 is high (complete sequence detected)
assign sequence_detected = p3;

endmodule