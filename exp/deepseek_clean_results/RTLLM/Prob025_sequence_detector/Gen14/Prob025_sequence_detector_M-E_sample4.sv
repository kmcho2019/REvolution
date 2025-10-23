module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] history_buffer;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        history_buffer <= 4'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Shift new bit into history buffer
        history_buffer <= {history_buffer[2:0], data_in};
        
        // Pattern detection with edge triggering
        sequence_detected <= (history_buffer == 4'b1001) && (data_in == 1'b1);
    end
end

endmodule