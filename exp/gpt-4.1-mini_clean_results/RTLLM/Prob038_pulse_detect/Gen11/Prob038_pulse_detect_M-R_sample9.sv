module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE      = 2'd0; // waiting for data_in=1
    localparam HIGH      = 2'd1; // detected data_in=1, waiting for 0 to complete pulse
    localparam PULSE_END = 2'd2; // pulse detected (0->1->0)

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (~data_in)
                    next_state = PULSE_END;
                else
                    next_state = HIGH;
            end
            PULSE_END: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic - asserted for one cycle in PULSE_END state
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            data_out <= 1'b0;
        else
            data_out <= (state == PULSE_END) ? 1'b1 : 1'b0;
    end

endmodule