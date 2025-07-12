module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding
    localparam IDLE = 5'b00001,
               S1   = 5'b00010,
               S2   = 5'b00100,
               S3   = 5'b01000,
               S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Synchronous state update with active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational next state logic for sequence "1001" using one-hot encoding
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;                   // Wait for '1'
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;           // After '1', expect '0'
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;           // After '10', expect '0' or restart if '1'
            S3:   next_state = data_in ? S4 : IDLE;                   // After '100', expect '1' to detect
            S4:   next_state = data_in ? S1 : IDLE;                   // After detection, allow overlapping
            default: next_state = IDLE;
        endcase
    end

    // Output logic: assert sequence_detected for one cycle when entering S4
    // Add enable to reduce toggling by updating only on transitions or S4
    reg next_seq_detected;
    always @(*) begin
        next_seq_detected = (next_state == S4);
    end

    always @(posedge clk) begin
        if (!rst_n)
            sequence_detected <= 1'b0;
        else if (sequence_detected != next_seq_detected)
            sequence_detected <= next_seq_detected;
    end

endmodule