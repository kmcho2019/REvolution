module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Idle state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // Transition to Byte1 state
                end else begin
                    state <= 2'b00; // Stay in Idle state
                end
                done <= 1'b0;
            end
            2'b01: begin // Byte1 state
                state <= 2'b10; // Transition to Byte2 state
                done <= 1'b0;
            end
            2'b10: begin // Byte2 state
                state <= 2'b11; // Transition to Byte3 state
                done <= 1'b0;
            end
            2'b11: begin // Byte3 state
                state <= 2'b00; // Transition to Idle state
                done <= 1'b1; // Signal done
            end
        endcase
    end
end

endmodule