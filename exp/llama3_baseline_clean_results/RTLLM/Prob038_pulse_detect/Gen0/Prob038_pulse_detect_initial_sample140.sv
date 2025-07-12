module pulse_detect(
    input         clk,
    input         rst_n,
    input         data_in,
    output reg    data_out
);

reg [1:0] state;  // 0: IDLE, 1: RISING_EDGE, 2: FALLING_EDGE

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;  // IDLE
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin  // IDLE
                if (data_in) begin
                    state <= 2'b01;  // RISING_EDGE
                end else begin
                    state <= 2'b00;  // Stay in IDLE
                end
                data_out <= 1'b0;
            end
            2'b01: begin  // RISING_EDGE
                if (~data_in) begin
                    state <= 2'b10;  // FALLING_EDGE
                end else begin
                    state <= 2'b01;  // Stay in RISING_EDGE
                end
                data_out <= 1'b0;
            end
            2'b10: begin  // FALLING_EDGE
                state <= 2'b00;  // Back to IDLE
                data_out <= 1'b1;
            end
            default: begin
                state <= 2'b00;  // IDLE
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule