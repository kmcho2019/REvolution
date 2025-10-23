module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding: [3]1st bit, [2]2nd bit, [1]3rd bit, [0]4th bit
reg [3:0] state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= 4'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update state based on current state and input
        case (state)
            4'b0000: state <= data_in ? 4'b1000 : 4'b0000;  // Start with '1'
            4'b1000: state <= data_in ? 4'b1000 : 4'b0100;   // Expect '0'
            4'b0100: state <= data_in ? 4'b1000 : 4'b0010;   // Expect '0'
            4'b0010: state <= data_in ? 4'b0001 : 4'b0000;   // Expect '1'
            4'b0001: state <= data_in ? 4'b1000 : 4'b0000;   // Reset after detection
            default: state <= 4'b0000;
        endcase

        // Detection is simply when state equals the complete pattern
        sequence_detected <= (state == 4'b1001);
    end
end

endmodule