module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // current state of the pulse detection process

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        state <= 2'b00; // reset to idle state
        data_out <= 1'b0; // reset data_out to 0
    end else begin
        case (state)
            2'b00: begin // idle state
                if (data_in) begin
                    state <= 2'b01; // transition to rising state
                end
                data_out <= 1'b0; // data_out is 0 in idle state
            end
            2'b01: begin // rising state
                if (~data_in) begin
                    state <= 2'b10; // transition to falling state
                    data_out <= 1'b1; // set data_out to 1 at the end of a pulse
                end else begin
                    state <= 2'b01; // stay in rising state if data_in is still 1
                    data_out <= 1'b0; // data_out is 0 in rising state
                end
            end
            2'b10: begin // falling state
                state <= 2'b00; // transition back to idle state
                data_out <= 1'b0; // reset data_out to 0
            end
            default: begin
                state <= 2'b00; // default to idle state
                data_out <= 1'b0; // default data_out to 0
            end
        endcase
    end
end

endmodule