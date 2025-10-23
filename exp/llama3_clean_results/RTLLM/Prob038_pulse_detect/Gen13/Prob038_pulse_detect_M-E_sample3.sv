module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // Finite state machine state register
parameter IDLE = 2'b00, RISING_EDGE = 2'b01, HIGH = 2'b10, FALLING_EDGE = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= RISING_EDGE;
                end else begin
                    state <= IDLE;
                end
                data_out <= 1'b0;
            end
            RISING_EDGE: begin
                if (data_in == 1'b1) begin
                    state <= HIGH;
                end else begin
                    state <= IDLE;
                end
                data_out <= 1'b0;
            end
            HIGH: begin
                if (data_in == 1'b0) begin
                    state <= FALLING_EDGE;
                end else begin
                    state <= HIGH;
                end
                data_out <= 1'b0;
            end
            FALLING_EDGE: begin
                state <= IDLE;
                data_out <= 1'b1;
            end
            default: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule