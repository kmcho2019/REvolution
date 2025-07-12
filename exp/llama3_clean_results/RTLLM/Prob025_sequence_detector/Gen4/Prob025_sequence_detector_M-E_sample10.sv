module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the shift register to store the last 4 bits of the input data stream
reg [3:0] shift_reg;

// Initialize the shift register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0000;
        sequence_detected <= 1'b0;
    end else begin
        shift_reg <= {data_in, shift_reg[3:1]};
        if (shift_reg == 4'b1001) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule