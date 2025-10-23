module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
    } state_t;

    state_t current_state, next_state;

    // Sequential logic: state transition and output logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
        case (current_state)
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
                    next_state = S1;
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = IDLE;
            end
            S4: begin
                // After detection, restart detection for overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule