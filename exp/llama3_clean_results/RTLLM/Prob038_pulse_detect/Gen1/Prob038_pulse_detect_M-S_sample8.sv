module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        data_out <= 0;
    end else begin
        case(state)
            2'b00: begin // IDLE
                if (data_in) begin
                    state <= 2'b01; // PULSE_START
                    data_out <= 0;
                end else begin
                    state <= 2'b00; // IDLE
                    data_out <= 0;
                end
            end
            2'b01: begin // PULSE_START
                if (!data_in) begin
                    state <= 2'b10; // PULSE_END
                    data_out <= 1;
                end else begin
                    state <= 2'b01; // PULSE_START
                    data_out <= 0;
                end
            end
            2'b10: begin // PULSE_END
                state <= 2'b00; // IDLE
                data_out <= 0;
            end
            default: begin
                state <= 2'b00; // IDLE
                data_out <= 0;
            end
        endcase
    end
end

endmodule