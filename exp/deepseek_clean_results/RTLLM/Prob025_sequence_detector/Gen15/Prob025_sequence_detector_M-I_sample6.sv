module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] shift_reg;  // Stores last 3 bits
reg detect_100;       // Intermediate detection of "100"
reg enable_shift;     // Enable signal for shift register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        detect_100 <= 1'b0;
        sequence_detected <= 1'b0;
        enable_shift <= 1'b1;
    end else begin
        // First pipeline stage: detect "100" in shift register
        detect_100 <= shift_reg[2] & ~shift_reg[1] & ~shift_reg[0];
        
        // Second pipeline stage: combine with current data_in
        sequence_detected <= detect_100 & data_in;
        
        // Clock gating logic: freeze shift register after detecting "100"
        enable_shift <= !(shift_reg[2] & ~shift_reg[1] & ~shift_reg[0]);
        
        // Conditional shift register update
        if (enable_shift) begin
            shift_reg <= {shift_reg[1:0], data_in};
        end
    end
end

endmodule