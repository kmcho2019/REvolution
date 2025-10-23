module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: idle, 1: rising_edge, 2: falling_edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // idle state
        data_out <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (data_in) begin
                    state <= 1; // transition to rising_edge state
                    data_out <= 0;
                end else begin
                    state <= 0; // stay in idle state
                    data_out <= 0;
                end
            end
            1: begin // rising_edge state
                if (~data_in) begin
                    state <= 2; // transition to falling_edge state
                    data_out <= 0;
                end else begin
                    state <= 1; // stay in rising_edge state
                    data_out <= 0;
                end
            end
            2: begin // falling_edge state
                state <= 0; // transition to idle state
                data_out <= 1; // set data_out to 1
            end
            default: begin
                state <= 0; // default to idle state
                data_out <= 0;
            end
        endcase
    end
end

endmodule