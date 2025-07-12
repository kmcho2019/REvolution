module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    typedef enum reg [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
    } state_t;

    state_t current_state, next_state;

    // State transition logic (combinational)
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
                    next_state = S1;  // Stay here since sequence starts with '1', 
                                      // but could interpret as new start if input is '1'
            end

            S2: begin
                if (data_in == 0)
                    next_state = IDLE;  // sequence mismatch, restart
                else
                    next_state = S3;
            end

            S3: begin
                if (data_in == 1)
                    next_state = S4;
                else
                    next_state = S1; // If '0', sequence partially matched "1", so go to S1
            end

            S4: begin
                if (data_in == 1)
                    next_state = S1; // sequence_detected, check for overlapping sequences
                else
                    next_state = S2;
            end

            default: next_state = IDLE;
        endcase
    end

    // State update (sequential)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

endmodule