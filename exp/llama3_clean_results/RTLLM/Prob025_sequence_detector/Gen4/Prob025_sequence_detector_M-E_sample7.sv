module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the shift register to hold the last 4 bits
reg [3:0] shift_reg;

// Initialize the shift register
initial shift_reg = 4'b0000;

// Define the desired sequence
localparam DESIRED_SEQUENCE = 4'b1001;

// Detect sequence logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_reg <= 4'b0000;
        sequence_detected <= 1'b0;
    end else begin
        // Shift in the new bit and shift out the oldest bit
        shift_reg <= {shift_reg[2:0], data_in};
        
        // Compare the shift register contents with the desired sequence
        if (shift_reg == DESIRED_SEQUENCE) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule