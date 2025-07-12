module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the desired sequence
reg [3:0] desired_sequence = 4'b1001;

// Initialize the match counter
reg [1:0] match_counter = 2'b00;

// Initialize the bit position
reg [1:0] bit_position = 2'b00;

// State machine to manage the counter and assert the output
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        match_counter <= 2'b00;
        bit_position <= 2'b00;
    end else begin
        if (data_in == desired_sequence[bit_position]) begin
            match_counter <= match_counter + 1'b1;
        end else begin
            match_counter <= 2'b00;
        end
        bit_position <= bit_position + 1'b1;
        if (bit_position == 2'b11) begin
            bit_position <= 2'b00;
        end
    end
end

// Output logic to detect the sequence
assign sequence_detected = (match_counter == 2'b11);

endmodule