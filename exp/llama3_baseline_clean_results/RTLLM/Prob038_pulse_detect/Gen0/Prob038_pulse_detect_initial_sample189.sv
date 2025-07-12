module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register
parameter IDLE = 2'b00, RISING_EDGE = 2'b01, FALLING_EDGE = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING_EDGE;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING_EDGE: begin
                if (~data_in) begin
                    state <= FALLING_EDGE;
                    data_out <= 0;
                end else begin
                    state <= RISING_EDGE;
                    data_out <= 0;
                end
            end
            FALLING_EDGE: begin
                if (~data_in) begin
                    state <= IDLE;
                    data_out <= 1;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 0;
            end
        endcase
    end
end

endmodule