module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit state register
parameter IDLE = 2'b00; // initial state
parameter RISING = 2'b01; // data_in transitions from 0 to 1
parameter HIGH = 2'b10; // data_in remains 1
parameter FALLING = 2'b11; // data_in transitions from 1 to 0

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            RISING: begin
                if (data_in) begin
                    state <= HIGH;
                    data_out <= 0;
                end else begin
                    state <= IDLE;
                    data_out <= 0;
                end
            end
            HIGH: begin
                if (~data_in) begin
                    state <= FALLING;
                    data_out <= 0;
                end else begin
                    state <= HIGH;
                    data_out <= 0;
                end
            end
            FALLING: begin
                if (~data_in) begin
                    state <= IDLE;
                    data_out <= 1; // set data_out to 1 at the end of the pulse
                end else begin
                    state <= HIGH;
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