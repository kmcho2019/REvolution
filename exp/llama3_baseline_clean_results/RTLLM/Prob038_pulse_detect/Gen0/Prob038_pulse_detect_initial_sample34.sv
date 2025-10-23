module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: idle, 1: rising, 2: falling, 3: pulse_detected

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // idle state
        data_out <= 0;
    end else begin
        case(state)
            0: begin // idle state
                if (data_in) begin
                    state <= 1; // rising state
                    data_out <= 0;
                end else begin
                    state <= 0; // stay in idle state
                    data_out <= 0;
                end
            end
            1: begin // rising state
                if (~data_in) begin
                    state <= 2; // falling state
                    data_out <= 0;
                end else begin
                    state <= 1; // stay in rising state
                    data_out <= 0;
                end
            end
            2: begin // falling state
                if (data_in) begin
                    state <= 1; // go back to rising state
                    data_out <= 0;
                end else begin
                    state <= 3; // pulse_detected state
                    data_out <= 1;
                end
            end
            3: begin // pulse_detected state
                if (data_in) begin
                    state <= 1; // go back to rising state
                    data_out <= 0;
                end else begin
                    state <= 0; // go back to idle state
                    data_out <= 0;
                end
            end
            default: begin
                state <= 0; // go back to idle state
                data_out <= 0;
            end
        endcase
    end
end

endmodule