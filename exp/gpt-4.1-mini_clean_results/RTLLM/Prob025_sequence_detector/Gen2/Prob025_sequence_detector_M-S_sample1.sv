module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum reg [1:0] {IDLE, S1, S2, S3} state_t;
    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State update and output logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected is high only when sequence 1001 is detected at S3 with data_in=1
            // Here, sequence_detected should be asserted when we get the last bit '1' at S3, which causes transition to S1
            sequence_detected <= (state == S3) && data_in;
        end
    end

endmodule