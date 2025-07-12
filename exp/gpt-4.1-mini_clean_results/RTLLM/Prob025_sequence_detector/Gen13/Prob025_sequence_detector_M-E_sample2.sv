module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // Active-low asynchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding (5 states)
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Asynchronous reset, synchronous state update
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // stays if input 1, since sequence start detected again
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // restart from S1 if input 1
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4; // Sequence matched here
                else
                    next_state = IDLE; // no match, restart
            end
            S4: begin
                // After detecting sequence, check input to start new detection
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted only when state machine enters S4
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule