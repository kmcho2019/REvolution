module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] state; // States: 2'b00 - Idle, 2'b01 - S0, 2'b10 - S1, 2'b11 - S2/S3
reg valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 4'b0;
        state <= 2'b00; // Reset to idle state
        valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (d!== 4'b0) begin // New data available
                    data <= d;
                    state <= 2'b01; // Transition to S0
                    valid <= 1'b1;
                end
            end
            2'b01: begin // S0
                state <= 2'b10; // Transition to S1
                valid <= 1'b1;
            end
            2'b10: begin // S1
                state <= 2'b11; // Transition to S2/S3
                valid <= 1'b1;
            end
            2'b11: begin // S2/S3
                state <= 2'b00; // Return to idle state
                valid <= 1'b1;
            end
            default: state <= 2'b00;
        endcase
    end
end

assign dout = (state == 2'b01)? data[3] :
              (state == 2'b10)? data[2] :
              (state == 2'b11)? (data[1:0] == 2'b00)? data[1] : data[0] :
              1'b0;

assign valid_out = valid;

endmodule