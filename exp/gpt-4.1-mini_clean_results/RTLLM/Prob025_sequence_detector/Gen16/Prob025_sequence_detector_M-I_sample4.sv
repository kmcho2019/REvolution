module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding for 4 states: IDLE, S1, S2, S3
    localparam IDLE = 4'b0001,
               S1   = 4'b0010,
               S2   = 4'b0100,
               S3   = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic with one-hot encoding
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S1 : IDLE; // On data_in=1 at S3, sequence "1001" detected
            default: next_state = IDLE;
        endcase
    end

    // Output logic: combinational assertion based on next state completion
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            // sequence_detected asserted when the sequence "1001" is completed,
            // which occurs when current state is S3 and data_in=1 (transitioning to S1)
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule