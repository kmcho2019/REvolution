module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // asynchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (2 bits suffice for 4 states)
    localparam [1:0]
        IDLE  = 2'b00,   // no bits matched yet
        S1    = 2'b01,   // matched '1'
        S10   = 2'b10,   // matched '10'
        S100  = 2'b11;   // matched '100'

    reg [1:0] state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: 
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;

            S1:
                if (!data_in)
                    next_state = S10;    // matched "10"
                else
                    next_state = S1;     // another '1', stay in S1

            S10:
                if (!data_in)
                    next_state = S100;   // matched "100"
                else
                    next_state = S1;     // '1' detected, possible restart

            S100:
                if (data_in)
                    next_state = S1;     // sequence complete on next bit if '1'
                else
                    next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end

    // Output logic (Mealy): sequence_detected asserted combinationally when last bit matches
    always @(*) begin
        sequence_detected = (state == S100) && (data_in == 1'b1);
    end

endmodule