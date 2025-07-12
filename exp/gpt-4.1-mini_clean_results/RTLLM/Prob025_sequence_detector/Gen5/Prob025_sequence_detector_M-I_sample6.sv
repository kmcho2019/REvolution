module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding for clarity and potential timing improvement
    localparam IDLE = 4'b0001;    // No bits matched
    localparam S1   = 4'b0010;    // Matched '1'
    localparam S2   = 4'b0100;    // Matched "10"
    localparam S3   = 4'b1000;    // Matched "100"

    reg [3:0] state, next_state;

    // Next-state logic combinational
    always @(*) begin
        // Default next state is IDLE to avoid latches
        next_state = IDLE;
        case (state)
            IDLE: begin
                next_state = data_in ? S1 : IDLE;
            end
            S1: begin
                next_state = data_in ? S1 : S2;
            end
            S2: begin
                next_state = data_in ? S3 : IDLE;
            end
            S3: begin
                // After detecting "100", if next bit is '1' sequence_detected = 1,
                // next state depends on input bit for overlapping detection
                next_state = data_in ? S1 : S2;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Mealy output)
    always @(*) begin
        // sequence_detected is asserted when the FSM is in S3 and data_in == 1,
        // meaning the full "1001" sequence is detected on this cycle.
        sequence_detected = (state == S3) && data_in;
    end

endmodule