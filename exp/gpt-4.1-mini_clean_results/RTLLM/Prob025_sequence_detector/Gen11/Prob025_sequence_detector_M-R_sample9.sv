module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output wire sequence_detected
);

    // Binary encoding for FSM states
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state, next_state;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational next-state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1; // Stay in S1 to allow overlapping sequences
            end

            S2: begin
                if (!data_in)
                    next_state = S3;
                else
                    next_state = IDLE;
            end

            S3: begin
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE;
            end

            S4: begin
                // After detecting sequence, allow overlapping sequences
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output combinational logic: assert sequence_detected when in S4 state
    assign sequence_detected = (state == S4);

endmodule