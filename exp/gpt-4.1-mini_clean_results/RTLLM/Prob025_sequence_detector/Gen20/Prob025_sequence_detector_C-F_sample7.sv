module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (3 bits) for FSM states
    localparam IDLE = 3'd0,   // Waiting for first '1'
               S1   = 3'd1,   // Matched '1'
               S2   = 3'd2,   // Matched "10"
               S3   = 3'd3,   // Matched "100"
               S4   = 3'd4;   // Matched "1001" (final detection state)

    reg [2:0] state, next_state;

    // Combinational logic: determine next state based on current state and input
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for first bit '1' to start matching
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                // After detecting '1', expecting '0' next for sequence, but if '1' again stay in S1 (handle overlapping)
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                // After "10", expect another '0' to continue, if '1' restart from S1 (since first bit matches)
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end

            S3: begin
                // After "100", expecting '1' to complete "1001"
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end

            S4: begin
                // Sequence detected; allow overlapping sequences
                // If next input is '1' go to S1, else IDLE
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and output generation with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Assert sequence_detected for one cycle when entering S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule