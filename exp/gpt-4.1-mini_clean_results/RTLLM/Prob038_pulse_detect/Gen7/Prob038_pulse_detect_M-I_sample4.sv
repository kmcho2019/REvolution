module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Binary state encoding
    localparam [1:0]
        WAIT_FOR_FIRST_ZERO  = 2'b00,
        WAIT_FOR_ONE         = 2'b01,
        WAIT_FOR_SECOND_ZERO = 2'b10;

    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            WAIT_FOR_FIRST_ZERO: 
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_ONE;
                else
                    next_state = WAIT_FOR_FIRST_ZERO;
            WAIT_FOR_ONE:
                if (data_in == 1'b1)
                    next_state = WAIT_FOR_SECOND_ZERO;
                else
                    next_state = WAIT_FOR_FIRST_ZERO;
            WAIT_FOR_SECOND_ZERO:
                if (data_in == 1'b0)
                    next_state = WAIT_FOR_FIRST_ZERO;
                else
                    next_state = WAIT_FOR_SECOND_ZERO;
            default:
                next_state = WAIT_FOR_FIRST_ZERO;
        endcase
    end

    // Sequential state and output update with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= WAIT_FOR_FIRST_ZERO;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is asserted when current state is WAIT_FOR_SECOND_ZERO and data_in==0,
            // indicating the pulse ended this cycle
            data_out <= (state == WAIT_FOR_SECOND_ZERO) && (data_in == 1'b0);
        end
    end

endmodule