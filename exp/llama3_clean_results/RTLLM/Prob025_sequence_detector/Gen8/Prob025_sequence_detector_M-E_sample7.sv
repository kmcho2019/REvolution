module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the desired sequence
parameter DESIRED_SEQUENCE[0:3] = {1'b1, 1'b0, 1'b0, 1'b1};

// Counter to keep track of the correct sequence bits
reg [1:0] counter;

// Internal signal to hold the current expected bit
reg [0:3] expected_bit;

// Initialize the counter and expected bit
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        counter <= 2'b00; // Reset the counter
        expected_bit <= 3'b000; // Reset the expected bit counter
    end else begin
        if (data_in == DESIRED_SEQUENCE[expected_bit]) begin
            if (expected_bit < 3) begin
                expected_bit <= expected_bit + 1'b1; // Move to the next expected bit
                counter <= counter + 1'b1; // Increment the counter
            end else begin
                counter <= 2'b00; // Reset the counter after sequence detection
                expected_bit <= 3'b000; // Reset the expected bit counter
            end
        end else begin
            counter <= 2'b00; // Reset the counter on mismatch
            expected_bit <= 3'b000; // Reset the expected bit counter
        end
    end
end

// Assert sequence_detected when the counter reaches the length of the desired sequence
assign sequence_detected = (counter == 2'd4);

endmodule