module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE         = 2'd0;
    localparam HIGH         = 2'd1;
    localparam PULSE_DETECT = 2'd2;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (~data_in)
                    next_state = PULSE_DETECT; // pulse end detected
                else
                    next_state = HIGH;
            end
            PULSE_DETECT: begin
                // After pulse detection, return to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State and output registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= (next_state == PULSE_DETECT) ? 1'b1 : 1'b0;
        end
    end

endmodule