module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // States with binary encoding
    localparam [1:0] IDLE = 2'b00,
                     S1   = 2'b01,
                     S2   = 2'b10,
                     S3   = 2'b11;

    reg [1:0] state, next_state;

    // State transition
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic - detect '1' in S3 state
    always @(*) begin
        sequence_detected = (state == S3) && data_in;
    end

endmodule