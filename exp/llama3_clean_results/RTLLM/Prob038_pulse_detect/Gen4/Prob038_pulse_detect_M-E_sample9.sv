module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 3-state FSM: IDLE, RISING, FALLING
reg prev_data_in; // Previous value of data_in

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0; // IDLE state
        prev_data_in <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // RISING state
                end
                data_out <= 0;
            end
            1: begin // RISING state
                if (!data_in) begin
                    state <= 2; // FALLING state
                end
                data_out <= 0;
            end
            2: begin // FALLING state
                if (!data_in) begin
                    data_out <= 1; // Pulse detected
                    state <= 0; // IDLE state
                end else begin
                    state <= 1; // RISING state
                    data_out <= 0;
                end
            end
        endcase
        prev_data_in <= data_in; // Update previous value of data_in
    end
end

endmodule