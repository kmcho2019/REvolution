module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding: 1-bit
    // 0: waiting for rising edge (IDLE)
    // 1: seen rising edge, waiting for falling edge (HIGH)
    reg state, next_state;

    // Next state logic and pulse detection (Mealy)
    wire pulse_detect = (state == 1'b1) && (data_in == 1'b0);

    always @(*) begin
        case (state)
            1'b0: next_state = data_in ? 1'b1 : 1'b0;
            1'b1: next_state = data_in ? 1'b1 : 1'b0;
            default: next_state = 1'b0;
        endcase
    end

    // State register and output register update
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= pulse_detect;
        end
    end

endmodule