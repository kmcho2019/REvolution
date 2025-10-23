module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01, // Detected '1'
        S2   = 2'b10, // Detected '10'
        S3   = 2'b11  // Detected '100'
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            // sequence_detected is high only if in S3 state and data_in == 1 (completes 1001)
            sequence_detected <= (current_state == S3) && (data_in == 1'b1);
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: next_state = data_in ? S1 : IDLE;

            S1:   next_state = data_in ? S1 : S2;

            S2:   next_state = data_in ? S1 : S3;

            S3:   // On receiving last bit (data_in), sequence detection happens
                   // If data_in==1, detected 1001, go to S1 for overlapping; else go to IDLE
                   next_state = data_in ? S1 : IDLE;

            default: next_state = IDLE;
        endcase
    end

endmodule