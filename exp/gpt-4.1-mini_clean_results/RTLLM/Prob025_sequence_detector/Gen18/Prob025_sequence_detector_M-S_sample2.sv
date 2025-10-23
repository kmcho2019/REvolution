module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam IDLE = 3'd0,
               S1   = 3'd1,  // matched '1'
               S2   = 3'd2,  // matched '10'
               S3   = 3'd3;  // matched '100'

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: 
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            S1:
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1;
            S2:
                if (!data_in)
                    next_state = S3;
                else
                    next_state = S1;
            S3:
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted when in S3 and data_in == 1 (final bit matched)
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule