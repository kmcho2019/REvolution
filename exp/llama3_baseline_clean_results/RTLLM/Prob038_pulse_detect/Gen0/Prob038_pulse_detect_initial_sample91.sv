module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // IDLE state
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in) begin
                    state <= 2'b01; // RISING state
                    data_out <= 1'b0;
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                    data_out <= 1'b0;
                end
            end
            2'b01: begin // RISING state
                if (~data_in) begin
                    state <= 2'b10; // FALLING state
                    data_out <= 1'b1;
                end else begin
                    state <= 2'b01; // Stay in RISING state
                    data_out <= 1'b0;
                end
            end
            2'b10: begin // FALLING state
                state <= 2'b00; // Go back to IDLE state
                data_out <= 1'b0;
            end
            default: begin
                state <= 2'b00; // Go back to IDLE state
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule