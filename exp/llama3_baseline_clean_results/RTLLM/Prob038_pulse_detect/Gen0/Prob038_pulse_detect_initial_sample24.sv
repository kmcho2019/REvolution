module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
parameter IDLE = 2'b00; // initial state
parameter RISING = 2'b01; // state after rising edge
parameter FALLING = 2'b10; // state after falling edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= IDLE; // reset state register to initial state
        data_out <= 1'b0; // reset output to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin // rising edge
                    state <= RISING;
                    data_out <= 1'b0;
                end else begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            end
            RISING: begin
                if (~data_in) begin // falling edge
                    state <= FALLING;
                    data_out <= 1'b1; // indicate pulse
                end else begin
                    state <= RISING;
                    data_out <= 1'b0;
                end
            end
            FALLING: begin
                state <= IDLE; // return to initial state
                data_out <= 1'b0; // reset output
            end
        endcase
    end
end

endmodule