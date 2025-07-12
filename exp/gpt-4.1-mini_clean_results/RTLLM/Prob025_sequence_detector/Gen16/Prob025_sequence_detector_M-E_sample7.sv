module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // active low asynchronous reset
    input  wire data_in,
    output wire sequence_detected // combinational output (Mealy)
);

    // One-hot state encoding for 5 states
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000; // final state (optional for clarity)

    reg [4:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (one-hot) - designed for sequence "1001"
    always @(*) begin
        // Default stay in current state
        next_state = IDLE;

        case (state)
            IDLE: begin
                // Wait for '1' to start sequence
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                // Received '1', expect '0'
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1; // remain if input '1'
            end

            S2: begin
                // Received '10', expect '0'
                if (!data_in)
                    next_state = S3;
                else
                    // Restart from S1 if input is '1' (overlap)
                    next_state = S1;
            end

            S3: begin
                // Received '100', expect '1'
                if (data_in)
                    next_state = S1; // after detection, restart from S1 for overlap
                else
                    next_state = IDLE;
            end

            // S4 is unused as output is combinational and state moves directly back
            default: next_state = IDLE;
        endcase
    end

    // Combinational output - Mealy style
    // sequence_detected = 1 when current state is S3 and data_in=1 (i.e. on last bit of sequence)
    assign sequence_detected = (state == S3) && data_in;

endmodule