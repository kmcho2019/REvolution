module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: IDLE, 1: RISE, 2: HIGH, 3: FALL

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // IDLE state
        data_out <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data_in) begin
                    state <= 1; // RISE state
                    data_out <= 0;
                end else begin
                    state <= 0; // IDLE state
                    data_out <= 0;
                end
            end
            1: begin // RISE state
                if (data_in) begin
                    state <= 2; // HIGH state
                    data_out <= 0;
                end else begin
                    state <= 0; // IDLE state
                    data_out <= 0;
                end
            end
            2: begin // HIGH state
                if (~data_in) begin
                    state <= 3; // FALL state
                    data_out <= 1;
                end else begin
                    state <= 2; // HIGH state
                    data_out <= 0;
                end
            end
            3: begin // FALL state
                state <= 0; // IDLE state
                data_out <= 0;
            end
        endcase
    end
end

endmodule