module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_capture_reg;
reg valid_capture;
reg [1:0] state; // 0: idle, 1: capture_first, 2: output

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_capture_reg <= 8'b0;
        valid_capture <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
        state <= 2'b00; // Reset to idle state
    end else begin
        case (state)
            2'b00: begin // Idle
                if (valid_in) begin
                    data_capture_reg <= data_in;
                    state <= 2'b01; // Move to capture_first state
                end
            end
            2'b01: begin // Capture first
                if (valid_in) begin
                    data_out <= {data_capture_reg, data_in};
                    valid_out <= 1'b1;
                    state <= 2'b00; // Return to idle after output
                end
            end
            default: state <= 2'b00; // Invalid state, return to idle
        endcase
    end
end

endmodule