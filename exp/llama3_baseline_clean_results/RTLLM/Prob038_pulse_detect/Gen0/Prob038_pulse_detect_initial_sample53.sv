module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: idle, 1: rising, 2: falling

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0; // reset to idle state
        data_out <= 0; // reset output to 0
    end else begin
        case (state)
            0: begin // idle state
                if (data_in) begin
                    state <= 1; // transition to rising state
                    data_out <= 0; // output remains 0
                end else begin
                    state <= 0; // stay in idle state
                    data_out <= 0; // output remains 0
                end
            end
            1: begin // rising state
                if (data_in) begin
                    state <= 2; // transition to falling state
                    data_out <= 0; // output remains 0
                end else begin
                    state <= 0; // transition back to idle state
                    data_out <= 0; // output remains 0
                end
            end
            2: begin // falling state
                if (~data_in) begin
                    state <= 0; // transition back to idle state
                    data_out <= 1; // output indicates end of pulse
                end else begin
                    state <= 2; // stay in falling state
                    data_out <= 0; // output remains 0
                end
            end
            default: begin
                state <= 0; // default to idle state
                data_out <= 0; // default output to 0
            end
        endcase
    end
end

endmodule