module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to store the current state
parameter IDLE = 2'b00, RISING = 2'b01, PULSE = 2'b10, FALLING = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE; // reset to IDLE state
        data_out <= 0; // reset data_out to 0
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING; // transition to RISING state
                end else begin
                    state <= IDLE; // stay in IDLE state
                end
                data_out <= 0; // data_out is 0 in IDLE state
            end
            RISING: begin
                if (data_in) begin
                    state <= PULSE; // transition to PULSE state
                end else begin
                    state <= IDLE; // transition back to IDLE state
                end
                data_out <= 0; // data_out is 0 in RISING state
            end
            PULSE: begin
                if (~data_in) begin
                    state <= FALLING; // transition to FALLING state
                end else begin
                    state <= PULSE; // stay in PULSE state
                end
                data_out <= 0; // data_out is 0 in PULSE state
            end
            FALLING: begin
                state <= IDLE; // transition back to IDLE state
                data_out <= 1; // data_out is 1 in FALLING state
            end
        endcase
    end
end

endmodule