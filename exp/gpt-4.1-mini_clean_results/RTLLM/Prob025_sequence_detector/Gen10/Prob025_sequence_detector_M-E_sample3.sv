module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1;  // detected '1'
    localparam S2   = 3'd2;  // detected "10"
    localparam S3   = 3'd3;  // detected "100"
    localparam S4   = 3'd4;  // detected "1001" (final state)

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Looking for first '1'
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                // Previously matched '1', now expect '0'
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // stay if '1' detected again, to handle overlaps
            end
            S2: begin
                // Previously matched "10", now expect '0'
                if (data_in == 1'b0)
                    next_state = S3;
                else if (data_in == 1'b1)
                    next_state = S1; // input=1 matches start of sequence
                else
                    next_state = IDLE; // default fallback, though unreachable
            end
            S3: begin
                // Previously matched "100", now expect '1' to complete sequence
                if (data_in == 1'b1)
                    next_state = S4;
                else if (data_in == 1'b0)
                    next_state = IDLE; // mismatch resets FSM
                else
                    next_state = IDLE; // default fallback
            end
            S4: begin
                // Sequence detected, now transition based on input to allow overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: asserted in state S4
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (next_state == S4);
    end

endmodule