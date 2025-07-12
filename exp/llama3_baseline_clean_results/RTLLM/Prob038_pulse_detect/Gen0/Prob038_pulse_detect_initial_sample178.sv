module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: FALLING
reg [1:0] counter; // counter to keep track of cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // IDLE state
        data_out <= 0; // no pulse
        counter <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin // rising edge
                    state <= 1; // RISING state
                    counter <= 1; // start counting
                    data_out <= 0; // no pulse yet
                end else begin
                    state <= 0; // stay in IDLE state
                    data_out <= 0; // no pulse
                end
            end
            1: begin // RISING state
                if (~data_in) begin // falling edge
                    state <= 2; // FALLING state
                    counter <= counter + 1; // increment counter
                    if (counter == 2) begin // complete pulse
                        data_out <= 1; // pulse detected
                    end else begin
                        data_out <= 0; // no pulse yet
                    end
                end else begin
                    state <= 1; // stay in RISING state
                    counter <= counter + 1; // increment counter
                    data_out <= 0; // no pulse yet
                end
            end
            2: begin // FALLING state
                state <= 0; // back to IDLE state
                if (counter == 2) begin // complete pulse
                    data_out <= 1; // pulse detected
                end else begin
                    data_out <= 0; // no pulse
                end
                counter <= 0; // reset counter
            end
        endcase
    end
end

endmodule