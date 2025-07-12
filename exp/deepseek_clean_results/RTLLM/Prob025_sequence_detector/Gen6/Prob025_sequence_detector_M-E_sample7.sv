module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] state;

// State transition logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= 2'b00;
        sequence_detected <= 1'b0;
    end
    else begin
        case (state)
            2'b00: // IDLE - looking for first '1'
                state <= data_in ? 2'b01 : 2'b00;
            2'b01: // '1' matched - looking for '0'
                state <= data_in ? 2'b00 : 2'b10;
            2'b10: // '10' matched - looking for '0'
                state <= data_in ? 2'b00 : 2'b11;
            2'b11: // '100' matched - looking for '1'
                state <= data_in ? 2'b01 : 2'b00;
        endcase
        
        // Output is high when we're in state '11' and get a '1'
        sequence_detected <= (state == 2'b11) && data_in;
    end
end

endmodule