module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam WAIT_FOR_RISE = 1'b0;
    localparam WAIT_FOR_FALL = 1'b1;

    reg state, next_state;
    reg data_in_d;  // delayed data_in for edge detection

    // Register delayed input for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_d <= 1'b0;
        else
            data_in_d <= data_in;
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= WAIT_FOR_RISE;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
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
            default:
                next_state = WAIT_FOR_RISE;
        endcase
    end

    // Output logic: registered pulse detection at falling edge after high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 1'b0;
        else
            // Assert data_out only when in WAIT_FOR_FALL state and detect falling edge of data_in (1->0)
            data_out <= (state == WAIT_FOR_FALL) && (data_in_d == 1'b1) && (data_in == 1'b0);
    end

endmodule