module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] pulse_state; // Register to track the state of the pulse detection process
localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam FALLING = 2'b10;

reg [1:0] pulse_counter; // Counter to track clock cycles since start of pulse

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        pulse_state <= IDLE;
        pulse_counter <= 2'b00;
        data_out <= 1'b0;
    end else begin
        case (pulse_state)
            IDLE: begin
                if (data_in) begin
                    pulse_state <= RISING;
                    pulse_counter <= 2'b01;
                end
            end
            RISING: begin
                if (!data_in) begin
                    pulse_state <= FALLING;
                    if (pulse_counter == 2'b01) begin
                        data_out <= 1'b1;
                    end else begin
                        data_out <= 1'b0;
                    end
                end else if (pulse_counter < 2'b11) begin
                    pulse_counter <= pulse_counter + 1'b1;
                end
            end
            FALLING: begin
                pulse_state <= IDLE;
                pulse_counter <= 2'b00;
                data_out <= 1'b0;
            end
            default: begin
                pulse_state <= IDLE;
            end
        endcase
    end
end

endmodule