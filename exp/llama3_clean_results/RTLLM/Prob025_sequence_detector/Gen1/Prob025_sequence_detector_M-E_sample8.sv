module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the target sequence
parameter TARGET_SEQUENCE = 4'b1001;

// Define the shift register width
parameter WIDTH = 4;

// Shift register
reg [WIDTH-1:0] shift_reg;

// Comparator output
assign sequence_detected = (shift_reg == TARGET_SEQUENCE);

// Shift register logic
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {data_in, shift_reg[WIDTH-1:1]};
    end
end

endmodule