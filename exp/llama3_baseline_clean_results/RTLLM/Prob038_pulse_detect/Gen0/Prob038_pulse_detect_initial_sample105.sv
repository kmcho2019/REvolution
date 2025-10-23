module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // idle state
        data_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (data_in) begin
                    state <= 2'b01; // rising edge detected
                end else begin
                    state <= 2'b00; // remain in idle state
                end
                data_out <= 1'b0;
            end
            2'b01: begin // rising edge detected
                if (data_in) begin
                    state <= 2'b10; // falling edge detected
                end else begin
                    state <= 2'b00; // return to idle state
                end
                data_out <= 1'b0;
            end
            2'b10: begin // falling edge detected
                if (~data_in) begin
                    state <= 2'b00; // return to idle state
                    data_out <= 1'b1; // indicate the end of a pulse
                end else begin
                    state <= 2'b10; // remain in falling edge detected state
                    data_out <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00; // return to idle state
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule