module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISING, 2: HIGH, 3: FALLING

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // reset to IDLE state
        data_out <= 0; // reset data_out to 0
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // transition to RISING state
                    data_out <= 0; // data_out remains 0
                end else begin
                    state <= 0; // stay in IDLE state
                    data_out <= 0; // data_out remains 0
                end
            end
            1: begin // RISING state
                if (data_in) begin
                    state <= 2; // transition to HIGH state
                    data_out <= 0; // data_out remains 0
                end else begin
                    state <= 0; // transition back to IDLE state
                    data_out <= 0; // data_out remains 0
                end
            end
            2: begin // HIGH state
                if (~data_in) begin
                    state <= 3; // transition to FALLING state
                    data_out <= 0; // data_out remains 0
                end else begin
                    state <= 2; // stay in HIGH state
                    data_out <= 0; // data_out remains 0
                end
            end
            3: begin // FALLING state
                if (~data_in) begin
                    state <= 0; // transition back to IDLE state
                    data_out <= 1; // set data_out to 1, indicating the end of a pulse
                end else begin
                    state <= 2; // transition back to HIGH state
                    data_out <= 0; // data_out remains 0
                end
            end
        endcase
    end
end

endmodule