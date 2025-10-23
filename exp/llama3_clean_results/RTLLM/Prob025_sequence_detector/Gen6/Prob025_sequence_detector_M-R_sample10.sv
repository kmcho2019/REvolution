module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the sequence detection
reg [2:0] state;

// Update the state
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= 3'b000; // IDLE state
    end else begin
        case (state)
            3'b000: state <= (data_in == 1'b1)? 3'b001 : 3'b000; // IDLE to S1
            3'b001: state <= (data_in == 1'b0)? 3'b010 : 3'b000; // S1 to S2
            3'b010: state <= (data_in == 1'b0)? 3'b011 : 3'b000; // S2 to S3
            3'b011: state <= (data_in == 1'b1)? 3'b100 : 3'b000; // S3 to S4
            3'b100: state <= 3'b000; // S4 to IDLE after detecting the sequence
            default: state <= 3'b000; // Reset to IDLE for any other state
        endcase
    end
end

// Assign the sequence_detected output directly based on state
assign sequence_detected = (state == 3'b100);

endmodule