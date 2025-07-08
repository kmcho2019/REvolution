module sequence_detector (
    input wire clk,
    input wire reset_n,
    input wire data_in,
    output reg sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1, // Detected '1'
        S2   = 3'd2, // Detected '10'
        S3   = 3'd3, // Detected '100'
        S4   = 3'd4  // Detected '1001'
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
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
                    next_state = IDLE;
                else // data_in == 1
                    next_state = S3;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else // data_in == 0
                    next_state = S2;
            end

            S4: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore machine: output depends only on current state)
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (current_state == S4);
    end

endmodule