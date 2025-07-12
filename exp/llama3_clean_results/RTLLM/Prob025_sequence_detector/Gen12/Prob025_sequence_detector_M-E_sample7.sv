module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Desired sequence
reg [3:0] desired_sequence = 4'b1001;

// Counter to keep track of the matched bits
reg [1:0] bit_counter;

// Current state of the sequence
reg [1:0] current_state;

// Next state logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        bit_counter <= 2'b00;
        current_state <= 2'b00;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            2'b00: begin // IDLE state
                if (data_in == desired_sequence[3]) begin // Check for first bit of sequence
                    bit_counter <= bit_counter + 1;
                    current_state <= 2'b01;
                end else begin
                    bit_counter <= 2'b00;
                end
            end
            2'b01: begin // First bit matched
                if (data_in == desired_sequence[2]) begin // Check for second bit of sequence
                    bit_counter <= bit_counter + 1;
                    current_state <= 2'b10;
                end else begin
                    bit_counter <= 2'b00;
                    current_state <= 2'b00;
                end
            end
            2'b10: begin // Second bit matched
                if (data_in == desired_sequence[1]) begin // Check for third bit of sequence
                    bit_counter <= bit_counter + 1;
                    current_state <= 2'b11;
                end else begin
                    bit_counter <= 2'b00;
                    current_state <= 2'b00;
                end
            end
            2'b11: begin // Third bit matched
                if (data_in == desired_sequence[0]) begin // Check for fourth bit of sequence
                    bit_counter <= bit_counter + 1;
                    sequence_detected <= 1'b1;
                    current_state <= 2'b00;
                end else begin
                    bit_counter <= 2'b00;
                    current_state <= 2'b00;
                end
            end
        endcase
    end
end

endmodule