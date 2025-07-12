module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding: number of bits matched (0 to 3)
    typedef enum reg [1:0] {
        STATE_0 = 2'd0, // No bits matched
        STATE_1 = 2'd1, // Matched '1'
        STATE_2 = 2'd2, // Matched '10'
        STATE_3 = 2'd3  // Matched '100'
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (!reset_n) begin
            current_state <= STATE_0;
            sequence_detected <= 1'b0;
        end else begin
            // Default output to 0; set to 1 only on sequence detection
            sequence_detected <= 1'b0;
            case (current_state)
                STATE_0: begin
                    if (data_in == 1'b1)
                        next_state = STATE_1;
                    else
                        next_state = STATE_0;
                end
                STATE_1: begin
                    if (data_in == 1'b0)
                        next_state = STATE_2;
                    else
                        next_state = STATE_1;
                end
                STATE_2: begin
                    if (data_in == 1'b0)
                        next_state = STATE_0;
                    else
                        next_state = STATE_3;
                end
                STATE_3: begin
                    if (data_in == 1'b1) begin
                        next_state = STATE_1;
                        sequence_detected <= 1'b1; // Sequence 1001 detected
                    end else begin
                        next_state = STATE_2;
                    end
                end
                default: next_state = STATE_0;
            endcase
            current_state <= next_state;
        end
    end

endmodule