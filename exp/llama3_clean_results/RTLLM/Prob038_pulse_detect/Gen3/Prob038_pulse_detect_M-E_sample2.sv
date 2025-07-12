module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

enum logic [1:0] {IDLE, PULSE_RISING, PULSE_FALLING, PULSE_DETECT} state;
reg prev_data_in;
reg [1:0] count;

always @(posedge clk) begin
    if (~rst_n) begin
        state <= IDLE;
        prev_data_in <= 0;
        count <= 0;
        data_out <= 0;
    end else begin
        prev_data_in <= data_in;

        case (state)
            IDLE: begin
                if (data_in && !prev_data_in) begin
                    state <= PULSE_RISING;
                end
                data_out <= 0;
            end
            PULSE_RISING: begin
                if (data_in) begin
                    count <= count + 1;
                    if (count == 2) begin
                        state <= PULSE_FALLING;
                    end
                end else begin
                    state <= IDLE;
                end
                data_out <= 0;
            end
            PULSE_FALLING: begin
                if (!data_in) begin
                    state <= PULSE_DETECT;
                end else begin
                    state <= PULSE_RISING;
                end
                data_out <= 0;
            end
            PULSE_DETECT: begin
                state <= IDLE;
                data_out <= 1;
                count <= 0;
            end
        endcase
    end
end

endmodule