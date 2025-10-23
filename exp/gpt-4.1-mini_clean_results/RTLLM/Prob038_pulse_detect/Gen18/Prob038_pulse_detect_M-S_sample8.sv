module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam PULSE_DETECTED = 1'b1;

    reg state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted only on falling edge after pulse detected
            if (state == PULSE_DETECTED && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

    always @(*) begin
        case(state)
            IDLE: 
                next_state = data_in ? PULSE_DETECTED : IDLE;
            PULSE_DETECTED:
                next_state = data_in ? PULSE_DETECTED : IDLE;
            default:
                next_state = IDLE;
        endcase
    end

endmodule