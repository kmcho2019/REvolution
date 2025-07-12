module sequence_detector (
    input  wire clk,
    input  wire reset_n,     // Active-low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (data_in) ? S1 : IDLE;
            S1:   next_state = (data_in) ? S1 : S2;
            S2:   next_state = (data_in) ? S1 : S3;
            S3:   next_state = (data_in) ? S4 : IDLE;
            S4:   next_state = (data_in) ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic (Moore output)
    assign sequence_detected = (state == S4);

endmodule