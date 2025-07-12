module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 0: idle, 1: rising, 2: high, 3: falling

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data_in) begin
                    state <= 1; // rising
                    data_out <= 0;
                end else begin
                    state <= 0;
                    data_out <= 0;
                end
            end
            1: begin // rising
                if (data_in) begin
                    state <= 2; // high
                    data_out <= 0;
                end else begin
                    state <= 0; // idle
                    data_out <= 0;
                end
            end
            2: begin // high
                if (~data_in) begin
                    state <= 3; // falling
                    data_out <= 0;
                end else begin
                    state <= 2; // high
                    data_out <= 0;
                end
            end
            3: begin // falling
                data_out <= 1;
                state <= 0; // idle
            end
            default: begin
                state <= 0;
                data_out <= 0;
            end
        endcase
    end
end

endmodule