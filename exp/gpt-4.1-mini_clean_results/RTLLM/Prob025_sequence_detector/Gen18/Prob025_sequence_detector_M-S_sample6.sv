module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active-low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding
    localparam IDLE = 2'b00,
               S1   = 2'b01,
               S2   = 2'b10,
               S3   = 2'b11;

    reg [1:0] state, next_state;

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
            IDLE: next_state = (data_in) ? S1 : IDLE;
            S1:   next_state = (data_in) ? S1 : S2;
            S2:   next_state = (data_in) ? S1 : S3;
            S3:   next_state = (data_in) ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic: combinationally detect sequence "1001" completion
    assign sequence_detected = (state == S3) && (data_in == 1'b1);

endmodule