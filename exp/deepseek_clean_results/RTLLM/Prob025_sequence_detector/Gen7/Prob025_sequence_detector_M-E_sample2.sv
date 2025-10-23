module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // 4-bit shift register to store recent inputs
    reg [3:0] history;
    
    // Detection flags for each possible starting position
    wire match_full = (history == 4'b1001);
    wire match_partial1 = (history[2:0] == 3'b001);
    wire match_partial2 = (history[1:0] == 2'b01);
    
    // State machine to validate temporal order
    reg [1:0] validation_state;
    localparam [1:0] 
        WAIT = 2'b00,
        GOT1 = 2'b01,
        GOT10 = 2'b10,
        GOT100 = 2'b11;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            history <= 4'b0;
            sequence_detected <= 1'b0;
            validation_state <= WAIT;
        end else begin
            // Shift in new data
            history <= {history[2:0], data_in};
            
            // Default detection output
            sequence_detected <= 1'b0;
            
            // State transitions and detection logic
            case (validation_state)
                WAIT: 
                    if (data_in) validation_state <= GOT1;
                
                GOT1: 
                    if (!data_in) validation_state <= GOT10;
                    else validation_state <= GOT1;
                
                GOT10: 
                    if (!data_in) validation_state <= GOT100;
                    else validation_state <= WAIT;
                
                GOT100: 
                    if (data_in) begin
                        sequence_detected <= 1'b1;
                        validation_state <= GOT1;  // Start new sequence
                    end else begin
                        validation_state <= GOT100;
                    end
            endcase
            
            // Parallel detection override (for immediate response)
            if (match_full) begin
                sequence_detected <= 1'b1;
                validation_state <= GOT1;  // Reset validation for next sequence
            end
        end
    end

endmodule