module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding for 5 states
    localparam IDLE = 5'b00001; // Waiting for '1'
    localparam S1   = 5'b00010; // matched '1'
    localparam S2   = 5'b00100; // matched '10'
    localparam S3   = 5'b01000; // matched '100'
    localparam S4   = 5'b10000; // matched '1001' - sequence detected

    reg [4:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        // Default to IDLE to avoid latches
        next_state = IDLE;
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2; // Allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // Register output; asserted when state S4 is reached
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule