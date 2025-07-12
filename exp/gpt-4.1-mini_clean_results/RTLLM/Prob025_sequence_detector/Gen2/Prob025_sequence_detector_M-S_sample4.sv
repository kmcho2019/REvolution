module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1, // matched '1'
        S2   = 3'd2, // matched '10'
        S3   = 3'd3, // matched '100'
        S4   = 3'd4  // matched '1001' (sequence detected)
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2; // allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // State and output update
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            sequence_detected <= (state == S4);
            state <= next_state;
        end
    end

endmodule