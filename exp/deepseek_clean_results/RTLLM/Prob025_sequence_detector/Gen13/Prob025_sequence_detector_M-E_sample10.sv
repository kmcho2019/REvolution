module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] match_counter;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        match_counter <= 2'b00;
        sequence_detected <= 1'b0;
    end
    else begin
        sequence_detected <= 1'b0;
        
        case (match_counter)
            2'b00: // Waiting for first '1'
                if (data_in == 1'b1)
                    match_counter <= 2'b01;
            
            2'b01: // Expecting '0'
                if (data_in == 1'b0)
                    match_counter <= 2'b10;
                else
                    match_counter <= 2'b00;
            
            2'b10: // Expecting '0'
                if (data_in == 1'b0)
                    match_counter <= 2'b11;
                else
                    match_counter <= 2'b00;
            
            2'b11: // Expecting '1'
                if (data_in == 1'b1) begin
                    sequence_detected <= 1'b1;
                    match_counter <= 2'b00; // Reset for new sequence
                end
                else
                    match_counter <= 2'b00;
        endcase
    end
end

endmodule