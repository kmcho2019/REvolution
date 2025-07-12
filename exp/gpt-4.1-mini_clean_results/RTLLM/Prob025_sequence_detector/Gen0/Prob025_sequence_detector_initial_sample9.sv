module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001, // Detected '1'
        S2   = 3'b010, // Detected '10'
        S3   = 3'b011, // Detected '100'
        S4   = 3'b100  // Detected '1001' - output asserted here
    } state_t;

    state_t state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // Stay in S1 if another '1' to handle overlap
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // restart sequence detection from first '1'
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = IDLE; // default to IDLE
            end
            S4: begin
                // After detection, decide where to go for overlapping detection
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and output assignment
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= (next_state == S4) ? 1'b1 : 1'b0;
        end
    end

endmodule