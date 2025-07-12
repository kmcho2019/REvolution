module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output wire sequence_detected
);

    // One-hot state encoding
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

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = (~data_in) ? S2 : S1;
            S2:   next_state = (~data_in) ? S3 : IDLE;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // sequence_detected asserted for one clock cycle when entering S4 state
    reg sequence_detected_reg;

    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected_reg <= 1'b0;
        else
            // sequence_detected is asserted when current state is S3 and next state is S4, i.e., sequence 1001 detected on current input
            sequence_detected_reg <= (state == S3) && (data_in == 1'b1);
    end

    assign sequence_detected = sequence_detected_reg;

endmodule