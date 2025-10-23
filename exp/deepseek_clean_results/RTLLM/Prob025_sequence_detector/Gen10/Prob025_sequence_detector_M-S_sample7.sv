module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] match_count; // Tracks how many bits of sequence we've matched

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        match_count <= 2'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        sequence_detected <= 1'b0;
        
        case (match_count)
            2'b00: if (data_in == 1'b1) match_count <= 2'b01; // First '1' matched
            2'b01: if (data_in == 1'b0) match_count <= 2'b10;  // '10' matched
                   else match_count <= 2'b00;
            2'b10: if (data_in == 1'b0) match_count <= 2'b11;  // '100' matched
                   else match_count <= 2'b00;
            2'b11: if (data_in == 1'b1) begin                // '1001' matched
                      sequence_detected <= 1'b1;
                      match_count <= 2'b00;
                   end
                   else match_count <= 2'b00;
        endcase
    end
end

endmodule