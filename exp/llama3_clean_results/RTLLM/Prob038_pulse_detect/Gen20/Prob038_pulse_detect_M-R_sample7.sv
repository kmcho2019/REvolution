module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // State register to track the pulse detection states
parameter IDLE = 2'b00, RISING_EDGE = 2'b01, PULSE_DETECT = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= RISING_EDGE;
                end
            end
            RISING_EDGE: begin
                if (data_in == 1'b0) begin
                    state <= PULSE_DETECT;
                end else begin
                    state <= RISING_EDGE;
                end
            end
            PULSE_DETECT: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

assign data_out = (state == PULSE_DETECT);

endmodule