module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg partial_match;
wire first_half_match = data_in == 1'b0;  // Looking for '0' after '1'
wire second_half_match = data_in == 1'b1; // Looking for '1' after '0'

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_match <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Clock gating - only update when needed
        if (partial_match || data_in) begin
            if (partial_match) begin
                // Second half check
                sequence_detected <= second_half_match;
                partial_match <= !second_half_match && data_in;
            end
            else begin
                // First half check
                partial_match <= first_half_match;
                sequence_detected <= 1'b0;
            end
        end
        else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule