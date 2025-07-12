module sequence_detector (
    input  wire clk,
    input  wire reset,            // Active-high synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoding of states (5 states)
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,  // matched '1'
               S2   = 5'b00100,  // matched "10"
               S3   = 5'b01000,  // matched "100"
               S4   = 5'b10000;  // detected "1001" - output logic state (not latched)

    reg [4:0] state, next_state;

    // Combinational logic for next state and output (Mealy FSM)
    always @(*) begin
        // Default assignments
        next_state = IDLE;
        sequence_detected = 1'b0;

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
                    next_state = S1;  // stay on '1' to allow sequences like 111...
            end

            S2: begin
                if (!data_in)
                    next_state = S3;
                else
                    next_state = S1;  // restart sequence on '1'
            end

            S3: begin
                if (data_in) begin
                    next_state = S1;      // after detection, allow overlapping sequences starting with '1'
                    sequence_detected = 1'b1; // sequence "1001" detected here (Mealy output)
                end else
                    next_state = IDLE;
            end

            // S4 state is not stored as we directly output on detection in S3 on data_in=1
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // output already assigned combinationally in always @(*) for Mealy behavior
            // so here we do not need to update sequence_detected again
            // But to keep output stable only one cycle, assign registered value here:
            // We'll delay Mealy output by one clock cycle by registering it:
        end
    end

    // Register the combinational output to make it synchronous and glitch-free
    reg sequence_detected_reg;
    always @(posedge clk) begin
        if (reset)
            sequence_detected_reg <= 1'b0;
        else
            sequence_detected_reg <= sequence_detected;
    end

    // Drive final output with registered Mealy output
    always @(posedge clk) begin
        if (reset)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= sequence_detected_reg;
    end

endmodule