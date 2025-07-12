module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Active-low asynchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (one-hot):
    // IDLE  = 5'b00001, waiting for first '1'
    // S1    = 5'b00010, matched '1'
    // S2    = 5'b00100, matched '10'
    // S3    = 5'b01000, matched '100'
    // S4    = 5'b10000, matched '1001' (final state - transient)

    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
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
                    next_state = S1;  // Stay in S1 if input is '1' (since sequence starts with 1)
            end

            S2: begin
                if (data_in == 0)
                    next_state = S3;
                else // data_in == 1
                    next_state = S1;
            end

            S3: begin
                if (data_in == 1)
                    next_state = S4;  // sequence detected, go to S4
                else
                    next_state = IDLE;
            end

            S4: begin
                // After detection, allow overlapping sequences:
                // If data_in == 1, next state is S1 else IDLE
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic (Mealy output: asserted when next_state is S4)
    // Since output depends on current state and data_in (which determines next state),
    // we assert sequence_detected when transition to S4 is taken.
    assign sequence_detected = (state == S3) && (data_in == 1'b1);

endmodule