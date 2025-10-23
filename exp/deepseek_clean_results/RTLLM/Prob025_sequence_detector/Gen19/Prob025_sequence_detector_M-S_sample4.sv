module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// One-hot encoded states
localparam IDLE  = 5'b00001;
localparam S1    = 5'b00010; // First '1' detected
localparam S2    = 5'b00100; // '10' detected
localparam S3    = 5'b01000; // '100' detected
localparam S4    = 5'b10000; // '1001' detected (output)

reg [4:0] state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                sequence_detected <= 1'b0;
                if (data_in) state <= S1;
                else state <= IDLE;
            end
            
            S1: begin
                if (!data_in) state <= S2;
                else state <= S1; // Stay if another '1'
            end
            
            S2: begin
                if (!data_in) state <= S3;
                else state <= S1; // Restart sequence
            end
            
            S3: begin
                if (data_in) begin
                    state <= S4;
                    sequence_detected <= 1'b1;
                end
                else state <= IDLE; // Sequence broken
            end
            
            S4: begin
                sequence_detected <= 1'b0;
                if (data_in) state <= S1; // Start new sequence
                else state <= S2;
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule