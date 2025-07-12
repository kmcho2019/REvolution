module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= 3'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Default outputs
        sequence_detected <= 1'b0;
        
        // State transitions
        case (state)
            3'b000: if (data_in) state <= 3'b001; // Saw '1'
            3'b001: if (!data_in) state <= 3'b010; // Saw '10'
                    else state <= 3'b001; // Stay on '1'
            3'b010: if (!data_in) state <= 3'b100; // Saw '100'
                    else state <= 3'b001; // Reset to '1'
            3'b100: if (data_in) begin // Saw '1001'
                        state <= 3'b001; // Start new '1'
                        sequence_detected <= 1'b1;
                    end
                    else state <= 3'b010; // Saw '1000' -> '100'
            default: state <= 3'b000;
        endcase
    end
end

endmodule