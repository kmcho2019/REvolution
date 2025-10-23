module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: initial state, 1: rising edge detection, 2: falling edge detection

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // initial state
                if (data_in) begin
                    state <= 1; // transition to rising edge detection state
                    data_out <= 0;
                end else begin
                    state <= 0;
                    data_out <= 0;
                end
            end
            1: begin // rising edge detection state
                if (~data_in) begin
                    state <= 0; // transition back to initial state
                    data_out <= 0;
                end else if (~data_in && state == 1) begin // to handle cases where data_in is only high for one clock cycle
                    state <= 2; // transition to falling edge detection state
                    data_out <= 1;
                end else begin
                    state <= 1;
                    data_out <= 0;
                end
            end
            2: begin // falling edge detection state
                if (~data_in) begin
                    data_out <= 1; // set output to 1
                    state <= 0; // transition back to initial state
                end else begin
                    state <= 1; // stay in rising edge detection state
                    data_out <= 0;
                end
            end
            default: begin
                state <= 0;
                data_out <= 0;
            end
        endcase
    end
end

endmodule