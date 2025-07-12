module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE      = 1'b0;
    localparam WAIT_FALL = 1'b1;

    reg state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for rising edge (0->1)
                if (data_in)
                    next_state = WAIT_FALL;
                else
                    next_state = IDLE;
            end
            WAIT_FALL: begin
                // Wait for falling edge (1->0)
                if (~data_in)
                    next_state = IDLE;
                else
                    next_state = WAIT_FALL;
            end
            default: next_state = IDLE;
        endcase
    end

    // State and output sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out only in cycle when pulse ends:
            // i.e. when in WAIT_FALL state and data_in goes low (next_state == IDLE)
            data_out <= (state == WAIT_FALL) && (~data_in);
        end
    end

endmodule