module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,  // matched '1'
        S2   = 3'd2,  // matched '10'
        S3   = 3'd3,  // matched '100'
        S4   = 3'd4   // matched '1001' (detect state)
    } state_t;

    state_t state, next_state;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            sequence_detected <= 1'b0;  // default deassert output

            case (state)
                IDLE: begin
                    if (data_in)
                        state <= S1; // first '1'
                    else
                        state <= IDLE;
                end
                S1: begin
                    if (!data_in)
                        state <= S2; // '10'
                    else
                        state <= S1; // still '1'
                end
                S2: begin
                    if (!data_in)
                        state <= S3; // '100'
                    else
                        state <= S1; // restart at '1'
                end
                S3: begin
                    if (data_in) begin
                        state <= S4;         // '1001' detected
                        sequence_detected <= 1'b1; // assert output
                    end else
                        state <= IDLE;       // restart
                end
                S4: begin
                    // After detection, check next bit for new sequence start
                    if (data_in)
                        state <= S1;
                    else
                        state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule