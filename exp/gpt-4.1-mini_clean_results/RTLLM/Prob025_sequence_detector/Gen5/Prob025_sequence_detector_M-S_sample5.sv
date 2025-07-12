module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,  // no bits matched
        S1   = 3'd1,  // matched '1'
        S2   = 3'd2,  // matched '10'
        S3   = 3'd3,  // matched '100'
        S4   = 3'd4   // matched '1001'
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    next_state = data_in ? S1 : IDLE;
                    sequence_detected <= 1'b0;
                end
                S1: begin
                    next_state = data_in ? S1 : S2;
                    sequence_detected <= 1'b0;
                end
                S2: begin
                    next_state = data_in ? S3 : IDLE;
                    sequence_detected <= 1'b0;
                end
                S3: begin
                    next_state = data_in ? S4 : S2;
                    sequence_detected <= 1'b0;
                end
                S4: begin
                    next_state = data_in ? S1 : S2;
                    sequence_detected <= 1'b1;  // Sequence detected
                end
                default: begin
                    next_state = IDLE;
                    sequence_detected <= 1'b0;
                end
            endcase
            state <= next_state;
        end
    end

endmodule