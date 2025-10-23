module sequence_detector (
    input  wire clk,
    input  wire reset_n,            // active-low asynchronous reset
    input  wire data_in,
    output wire sequence_detected   // one-cycle pulse when sequence "1001" detected
);

    // One-hot state encoding
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (data_in) ? S1 : IDLE;        // expect '1' to start sequence
            S1: 
                next_state = (data_in) ? S1 : S2;          // after '1', expect '0'
            S2: 
                next_state = (data_in) ? S1 : S3;          // after '10', expect '0' or restart
            S3: 
                next_state = (data_in) ? S4 : IDLE;        // after '100', expect '1' to complete
            S4:
                next_state = (data_in) ? S1 : IDLE;        // allow overlap detection
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic (Mealy): sequence_detected asserted when state is S3 and input is '1'
    // This indicates the sequence "1001" completed at current cycle input.
    assign sequence_detected = (state == S3) && data_in;

endmodule