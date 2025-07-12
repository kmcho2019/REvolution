module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // One-bit state encoding
    localparam WAIT_FOR_RISE = 1'b0;
    localparam WAIT_FOR_FALL = 1'b1;

    reg state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_FOR_RISE: 
                if (data_in)
                    next_state = WAIT_FOR_FALL;
                else
                    next_state = WAIT_FOR_RISE;
            WAIT_FOR_FALL:
                if (~data_in)
                    next_state = WAIT_FOR_RISE;
                else
                    next_state = WAIT_FOR_FALL;
            default: next_state = WAIT_FOR_RISE;
        endcase
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= WAIT_FOR_RISE;
        else
            state <= next_state;
    end

    // Output combinational logic: pulse detected at falling edge after high
    assign data_out = (state == WAIT_FOR_FALL) && (data_in == 1'b0);

endmodule