module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active-low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // One-hot state encoding for 4 states (IDLE, S1, S2, S3)
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
            S3:   next_state = data_in ? S1 : IDLE; // Detect "1001" on data_in=1 from S3
            default: next_state = IDLE;
        endcase
    end

    // Output is combinational: assert when current state is S3 and input is 1 (completing "1001")
    assign sequence_detected = (state == S3) && (data_in == 1'b1);

endmodule