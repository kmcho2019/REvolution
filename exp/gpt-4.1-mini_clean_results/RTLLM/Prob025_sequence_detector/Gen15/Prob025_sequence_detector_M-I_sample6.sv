module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot encoding of states
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        // Default next_state: stay in current state
        next_state = IDLE;

        case (1'b1)
            state[0]: next_state = data_in ? S1 : IDLE;      // IDLE
            state[1]: next_state = (data_in == 1'b0) ? S2 : S1;  // S1
            state[2]: next_state = (data_in == 1'b0) ? S3 : IDLE; // S2
            state[3]: next_state = data_in ? S4 : IDLE;          // S3
            state[4]: next_state = data_in ? S1 : IDLE;          // S4 (sequence detected)
            default:  next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted for one cycle when in S4 state
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule