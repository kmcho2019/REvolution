module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary)
    localparam IDLE = 3'b000,
               S1   = 3'b001, // detected '1'
               S2   = 3'b010, // detected "10"
               S3   = 3'b011; // detected "100"

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;        // waiting for '1'
            S1:   next_state = data_in ? S1 : S2;          // got '1', now expecting '0'
            S2:   next_state = data_in ? S1 : S3;          // got '10', now expecting '0'
            S3:   next_state = data_in ? S4 : IDLE;        // got '100', check last '1' for sequence
            default: next_state = IDLE;
        endcase
    end

    // Since we need a 4th state for full detection (S4), define it:
    localparam S4 = 3'b100; // sequence detected state (just for output pulse generation)

    // Adjust FSM for the fourth state:
    // Transition to S4 when sequence detected, then return to appropriate state to allow overlapping detection.

    // Re-implement next_state logic with S4:

    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;  // sequence detected on input=1 here
            S4:   next_state = data_in ? S1 : S2;    // allow overlapping detection after detection
            default: next_state = IDLE;
        endcase
    end

    // Output combinational logic for sequence_detected (asserted when in S4)
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (next_state == S4);
    end

endmodule