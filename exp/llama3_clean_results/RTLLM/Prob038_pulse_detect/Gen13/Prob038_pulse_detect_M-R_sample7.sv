module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register
parameter IDLE = 2'b00, PULSE_HIGH = 2'b01, PULSE_LOW = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE; // Initialize state to IDLE
        data_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= PULSE_HIGH;
                end else begin
                    state <= IDLE;
                end
                data_out <= 1'b0;
            end
            PULSE_HIGH: begin
                if (~data_in) begin
                    state <= PULSE_LOW;
                end else begin
                    state <= PULSE_HIGH;
                end
                data_out <= 1'b0;
            end
            PULSE_LOW: begin
                state <= IDLE;
                data_out <= 1'b1;
            end
        endcase
    end
end

endmodule